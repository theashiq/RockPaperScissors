//
//  GameSelectionViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation
import FirebaseFirestore


@MainActor
class GameSelectionViewModel: AlerterViewModel{
    
    private var db: Firestore
    private var gamesCollection: CollectionReference{
        db.collection("games")
    }
    
    public var authTracker: AuthTracker? = nil
    private(set) var player: (any Player)? = nil
    private(set) var opponent: (any Player)? = nil{
        didSet{
            proceedToGameView = true
        }
    }
    
    @Published var proceedToGameView: Bool = false
    
    override init() {
        db = Firestore.firestore()
    }
    
    private func createNewGame(user: AuthUser) -> DocumentReference?{
        let game = Game(p1Id: user.id, p1DisplayName: user.displayName)
        
        do{
            var ref = try gamesCollection.addDocument(from: game)
//            self.player = FirebasePlayer(id: user.id, displayName: user.displayName, gameDocument: ref)
            return ref
        }
        catch{
            return nil
        }
    }
    
    private func findAnEmptyGameDocId(authUserId: String) async -> DocumentReference? {
        print("find")
        do{
            let emptyGamesDocSnaps = try await gamesCollection
//                                                    .whereField("p2Id", isEqualTo: "")
                                                    .whereField("p1Id", isNotEqualTo: "")
                                                    .limit(to: 5)
                                                    .getDocuments()
            
            
            print(emptyGamesDocSnaps.documents.first?.documentID)
            
            return emptyGamesDocSnaps.documents.first { snap in
                do{
                    let game = try snap.data(as: Game.self)
                    return game.p2Id != authUserId
                }
                catch{
                    return false
                }
            }?.reference
        }
        catch{
            return nil
        }
    }
    
    private func joinGame(gameDocRef: DocumentReference, user: AuthUser) async -> Bool{
        
        do{
            var game = try await gameDocRef.getDocument().data(as: Game.self)
//            opponent = FirebaseOpponentPlayer(
//                id: game.id1,
//                displayName: game.displayName1,
//                gameDocument: gameDocRef
//            )
            
            game.p2Id = user.id
            game.p2DisplayName = user.displayName
            
            try gameDocRef.setData(from: game, merge: true)
//            player = FirebasePlayer(id: user.id, displayName: user.displayName, gameDocument: gameDocRef)
            return true
        }
        catch{
            return false
        }
    }
    
    //MARK: - User intents
    
    func singlePlayer(){
        player = SinglePlayer(displayName: "You")
        opponent = AiPlayer(displayName: "AI Player")
    }
    
    func multiplayer(onComplete: (() -> Void)? = nil) async {
    
        guard let user = authTracker?.user else{
            onComplete?()
            alert = .authErrorAlert(from: .notLoggedIn)
            return
        }
        
        var gameReference: DocumentReference? = nil
        
//      Find an empty game and join
        if let emptyGameDocRef = await findAnEmptyGameDocId(authUserId: user.id),
                                 await joinGame(gameDocRef: emptyGameDocRef, user: user) {
            gameReference = emptyGameDocRef
            print(107)
            print(gameReference?.documentID)
        }
//      Crate new game
        else if let newGameDocRef = createNewGame(user: user){
//          New game is created.
//          Now wait for an opponent to join and create Player2 when someone joins
            gameReference = newGameDocRef
            print(115)
            print(gameReference?.documentID)
        }
        else{
//          Failed to create new game
            alert = .alert("Oh no", "Failed to join server 1")
            onComplete?()
            return
        }
        
        if let gameReference{
            
            gameReference.addSnapshotListener { [weak self] docSnap, snapError in
                if let snapError{
                    self?.alert = .alert("Something Went Wrong", snapError.localizedDescription)
                    onComplete?()
                    return
                }
                do{
                    if let game = try docSnap?.data(as: Game.self), (!game.p1Id.isEmpty && !game.p2Id.isEmpty){
                        
                        if user.id == game.p1Id{
                            self?.player = FirebasePlayer(id: game.p1Id, displayName: game.p1DisplayName, gameDocument: gameReference)
                            self?.opponent = FirebasePlayer(id: game.p2Id, displayName: game.p2DisplayName, gameDocument: gameReference, isOpponent: true)
                        }
                        else{
                            self?.opponent = FirebasePlayer(id: game.p1Id, displayName: game.p1DisplayName, gameDocument: gameReference, isOpponent: true)
                            self?.player = FirebasePlayer(id: game.p2Id, displayName: game.p2DisplayName, gameDocument: gameReference)
                        }
                        
                        self?.proceedToGameView = true
                        onComplete?()
                    }
                }
                catch(let error){
                    self?.alert = .alert("Oh no", error.localizedDescription)
                    onComplete?()
                    return
                }
            }
        }
        else{
            alert = .alert("Oh no", "Failed to join server 3")
            onComplete?()
            return
        }
    }
}
