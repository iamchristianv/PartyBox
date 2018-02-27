//
//  Reference.swift
//  Partybox
//
//  Created by Christian Villa on 2/22/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum ReferenceKey: String {
    
    // MARK: - Database Keys
    
    case parties
    
    case games
    
    case packs
    
}

enum ReferenceNotification: String {
    
    // MARK: - Party Notification Types
    
    case partyHostChanged = "Party/PartyDetails/hostChanged"
    
    case partyDetailsChanged = "Party/PartyDetails/detailsChanged"
    
    case partyPeopleChanged = "Party/PartyPeople/peopleChanged"
    
    // MARK: - Game Notification Types
    
    case gameDetailsChanged = "Game/GameDetails/detailsChanged"
    
    case gamePeopleChanged = "Game/GamePeople/peopleChanged"
    
}

class Reference {
    
    // MARK: - Shared Instance
    
    static let current: Reference = Reference()
    
    // MARK: - Instance Properties
    
    let database: DatabaseReference = Database.database().reference()
    
    // MARK: - Party Functions
    
    func startParty(userName: String, partyName: String, callback: @escaping (String?) -> Void) {
        Party.current = Party()
        
        let id = Reference.current.randomPartyId()
        let path = "\(ReferenceKey.parties.rawValue)/\(id)"
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            User.current.name = userName
            
            Party.current.details.id = id
            Party.current.details.name = partyName
            Party.current.details.hostName = userName
            Party.current.people.add(PartyPerson(name: userName, JSON: JSON("")))
            
            let path = "\(ReferenceKey.parties.rawValue)"
            let value = Party.current.json
            
            Reference.current.database.child(path).updateChildValues(value)
            Reference.current.startObservingPartyChanges()
            
            callback(nil)
        })
    }
    
    func joinParty(userName: String, partyId: String, callback: @escaping (String?) -> Void) {
        Party.current = Party()
        
        let id = partyId
        let path = "\(ReferenceKey.parties.rawValue)/\(id)"
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            if snapshot.hasChild("\(PartyKey.people.rawValue)/\(userName)") {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            User.current.name = userName
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            let partyJSON = JSON(snapshotJSON)
            
            Party.current.details = PartyDetails(JSON: JSON(partyJSON[PartyKey.details.rawValue]))
            Party.current.people = PartyPeople(JSON: JSON(partyJSON[PartyKey.people.rawValue]))
            
            if Party.current.details.isClosed {
                callback("The host closed the party\n\nPlease try again later")
                return
            }
            
            if Party.current.people.count >= Party.current.details.capacity {
                callback("The party has already reached its max capacity\n\nPlease try again later")
                return
            }
            
            let person = PartyPerson(name: userName, JSON: JSON(""))
            Party.current.people.add(person)
            
            let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
            let value = person.json
            
            Reference.current.database.child(path).updateChildValues(value)
            Reference.current.startObservingPartyChanges()
            
            callback(nil)
        })
    }
    
    func endParty() {
        var path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)"
        
        if Party.current.people.count > 1 {
            path += "/\(PartyKey.people.rawValue)/\(User.current.name)"
        }
        
        Reference.current.stopObservingPartyChanges()
        Reference.current.database.child(path).removeValue()
        
        Party.current = Party()
    }
    
    func removePersonFromParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)/\(name)"
        
        Reference.current.database.child(path).removeValue(completionBlock: {
            (error, reference) in
            
            if let _ = error {
                callback("removePersonFromParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    func setHostForParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        let value = [PartyDetailsKey.hostName.rawValue: name]
        
        Reference.current.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, _) in
                        
            if let _ = error {
                callback("setHostForParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    func setNameForParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        let value = [PartyDetailsKey.name.rawValue: name]
        
        Reference.current.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, _) in
            
            if let _ = error {
                callback("setNameForParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    // MARK: - Party Notification Functions
    
    func startObservingPartyChanges() {
        self.startObservingPartyHostChanges()
        self.startObservingPartyDetailsChanges()
        self.startObservingPartyPeopleChanges()
    }
    
    func stopObservingPartyChanges() {
        self.stopObservingPartyHostChanges()
        self.stopObservingPartyDetailsChanges()
        self.stopObservingPartyPeopleChanges()
    }
    
    func startObservingPartyHostChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostName.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let hostName = snapshot.value as? String else { return }
            
            Party.current.details.hostName = hostName
            
            let name = Notification.Name(ReferenceNotification.partyHostChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPartyHostChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostName.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingPartyDetailsChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.details = PartyDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(ReferenceNotification.partyDetailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPartyDetailsChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingPartyPeopleChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.people = PartyPeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(ReferenceNotification.partyPeopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPartyPeopleChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    // MARK: - Game Functions
    
    func startGame(callback: @escaping (String?) -> Void) {
        Game.current = Game()
        
        let id = Party.current.details.id
        let path = "\(ReferenceKey.games.rawValue)/\(id)"
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }
            
            let path = "\(ReferenceKey.games.rawValue)"
            let value = Game.current.json
            
            Reference.current.database.child(path).updateChildValues(value)
            Reference.current.startObservingGameChanges()
            
            callback(nil)
        })
    }
    
    func endGame() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)"
        
        Reference.current.stopObservingGameChanges()
        Reference.current.database.child(path).removeValue()
        
        Game.current = Game()
    }
    
    func fetchPackCollectionForGame(callback: @escaping (String?) -> Void) {
        var path = "\(ReferenceKey.packs.rawValue)"
        
        switch Game.current.type {
        case .wannabe:
            path += "/\(Game.current.wannabe.details.id)/collection"
        }
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            Game.current.wannabe.pack.collection.removeAll()
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            let packJSON = JSON(snapshotJSON)
            
            for (_, values) in packJSON {
                Game.current.wannabe.pack.collection.append(values["name"].stringValue)
            }
            
            callback(nil)
        })
    }
    
    // MARK: - Game Notification Functions
    
    func startObservingGameChanges() {
        self.startObservingGameDetailsChanges()
        self.startObservingGamePeopleChanges()
    }
    
    func stopObservingGameChanges() {
        self.stopObservingGameDetailsChanges()
        self.stopObservingGamePeopleChanges()
    }
    
    func startObservingGameDetailsChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            switch Game.current.type {
            case .wannabe:
                Game.current.wannabe.details = WannabeDetails(JSON: JSON(snapshotJSON))
            }
            
            let name = Notification.Name(ReferenceNotification.gameDetailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingGameDetailsChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingGamePeopleChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            switch Game.current.type {
            case .wannabe:
                Game.current.wannabe.people = WannabePeople(JSON: JSON(snapshotJSON))
            }
            
            let name = Notification.Name(ReferenceNotification.gamePeopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingGamePeopleChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    // MARK: - Utility Functions
    
    func randomPartyId() -> String {
        var partyId = ""
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for _ in 1...4 {
            let randomIndex = Int(arc4random())
            
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])
            
            partyId += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }
        
        return partyId
    }
    
}
