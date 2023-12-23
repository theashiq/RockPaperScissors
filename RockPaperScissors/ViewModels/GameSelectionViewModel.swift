//
//  GameSelectionViewModel.swift
//  RockPaperScissors
//
//  Created by mac 2019 on 12/19/23.
//

import Foundation
import FirebaseFirestore

struct Game: Codable{
    var id1: String = ""
    var id2: String = ""
    var displayName1: String = ""
    var displayName2: String = ""
    var turn1: Int = 0
    var turn2: Int = 0
}

@MainActor
class GameSelectionViewModel: AlerterViewModel{
    
    private var db: Firestore
    private var gamesCollection: CollectionReference{
        db.collection("games")
    }
    
    public var authTracker: AuthTracker? = nil
    private(set) var player1: (any Player)? = nil
    private(set) var player2: (any Player)? = nil{
        didSet{
            proceedToGameView = true
        }
    }
    
    @Published var proceedToGameView: Bool = false
    
    override init() {
        db = Firestore.firestore()
    }
    
    func writeData(){
        Task{
            do{
                let ref = try await db.collection("user").addDocument(data: [
                  "first": "Ada",
                  "last": "Lovelace",
                  "born": 1815
                ])
                
                try await db.collection("user").document("TOK").setData([
                  "name": "Tokyo",
                  "country": "Japan",
                  "capital": true,
                  "population": 9000000,
                  "regions": ["kanto", "honshu"]
                ])
                try await db.collection("user").document("BJ").setData([
                  "name": "Beijing",
                  "country": "China",
                  "capital": true,
                  "population": 21500000,
                  "regions": ["jingjinji", "hebei"]
                ])
                
                print("Document added with ID: \(ref.documentID)")
            } catch {
                print("Error adding document: \(error)")
            }
            
            
            
        }
    }
    
    private func createNewGame(user: AuthUser) -> DocumentReference?{
        let game = Game(id1: user.id, displayName1: user.displayName)
        
        do{
            var ref = try gamesCollection.addDocument(from: game)
//            self.player1 = FirebasePlayer(id: user.id, displayName: user.displayName, gameDocument: ref)
            return ref
        }
        catch{
            return nil
        }
    }
    
    private func findAnEmptyGameDocId(authUserId: String) async -> DocumentReference? {
        do{
            let emptyGamesDocSnaps = try await gamesCollection
                                                    .whereField("id2", isEqualTo: "")
                                                    .whereField("id1", isNotEqualTo: authUserId)
                                                    .limit(to: 1)
                                                    .getDocuments()
            
            return emptyGamesDocSnaps.documents.first?.reference
        }
        catch{
            return nil
        }
    }
    
    private func joinGame(gameDocRef: DocumentReference, user: AuthUser) async -> Bool{
        
        do{
            var game = try await gameDocRef.getDocument().data(as: Game.self)
//            player2 = FirebaseOpponentPlayer(
//                id: game.id1,
//                displayName: game.displayName1,
//                gameDocument: gameDocRef
//            )
            
            game.id2 = user.id
            game.displayName2 = user.displayName
            
            try gameDocRef.setData(from: game, merge: true)
//            player1 = FirebasePlayer(id: user.id, displayName: user.displayName, gameDocument: gameDocRef)
            return true
        }
        catch{
            return false
        }
    }
    
    //MARK: - User intents
    
    func singlePlayer(){
        player1 = SinglePlayer(displayName: "You")
        player2 = AiPlayer(displayName: "AI Player")
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
        }
//      Crate new game
        else if let newGameDocRef = createNewGame(user: user){
//          New game is created.
//          Now wait for an opponent to join and create Player2 when someone joins
            gameReference = newGameDocRef
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
                    if let game = try docSnap?.data(as: Game.self), (!game.id1.isEmpty && !game.id2.isEmpty){
                        
                        if user.id == game.id1{
                            self?.player1 = FirebasePlayer(id: game.id1, displayName: game.displayName1, gameDocument: gameReference)
                            self?.player2 = FirebasePlayer(id: game.id2, displayName: game.displayName2, gameDocument: gameReference)
                        }
                        else{
                            self?.player2 = FirebasePlayer(id: game.id1, displayName: game.displayName1, gameDocument: gameReference)
                            self?.player1 = FirebasePlayer(id: game.id2, displayName: game.displayName2, gameDocument: gameReference)
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
