//
//  Session.swift
//  Partybox
//
//  Created by Christian Villa on 11/1/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum SessionKey: String {
    
    case party
    
    case game
    
}

enum SessionNotification: String {
    
    case partyChanged
    
    case gameChanged
    
}

class Session {
    
    // MARK: - Class Properties
    
    static let database: DatabaseReference = Database.database().reference()
    
    static var name: String = ""
    
    static var host: Bool = false
    
    static var code: String = ""
    
    static var party: Party = Party(JSON: JSON(""))
    
    static var game: Spyfall = Spyfall(JSON: JSON(""))
    
    // MARK: - JSON Methods
    
    static func toJSON() -> [String: Any] {
        let JSON = [
            Session.code: [
                SessionKey.party.rawValue: Session.party.toJSON(),
                SessionKey.game.rawValue: Session.game.toJSON()
            ]
        ] as [String: Any]
        
        return JSON
    }
    
    // MARK: - Database Methods
    
    static func start(partyName: String, personName: String, callback: @escaping (String?) -> Void) {
        let code = Session.randomCode()
        
        Session.database.child("sessions/\(code)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let codeUsed = snapshot.exists()
            
            if codeUsed {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            Session.name = personName
            Session.host = true
            Session.code = code
            Session.party = Party(details: PartyDetails(name: partyName), people: PartyPeople())
            Session.game = Spyfall(details: SpyfallDetails(), pack: SpyfallPack(), people: SpyfallPeople())
            
            let person = PartyPerson(name: personName, host: true)
            Session.party.people.add(person)
            
            Session.database.child("sessions").updateChildValues(Session.toJSON())
            
            callback(nil)
        })
    }
    
    static func end() {
        Session.database.child("sessions/\(Session.code)").removeValue()
        Session.code = ""
        Session.party = Party(JSON: JSON(""))
        Session.game = Spyfall(JSON: JSON(""))
    }
    
    static func join(code: String, personName: String, callback: @escaping (String?) -> Void) {
        Session.database.child("sessions/\(code)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let codeUsed = snapshot.exists()
            
            if !codeUsed {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            let personNameUsed = snapshot.hasChild("\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)/\(personName)")
            
            if personNameUsed {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            
            Session.name = personName
            Session.host = false
            Session.code = code
            Session.party = Party(JSON: sessionJSON[SessionKey.party.rawValue])
            Session.game = Spyfall(JSON: sessionJSON[SessionKey.game.rawValue])
            
            let person = PartyPerson(name: personName, host: false)
            Session.party.people.add(person)
            
            Session.database.child("sessions").updateChildValues(Session.toJSON())

            callback(nil)
        })
    }
    
    static func leave() {
        let path = "sessions/\(Session.code)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)/\(Session.name)"
        self.database.child(path).removeValue()
        Session.code = ""
        Session.party = Party(JSON: JSON(""))
        Session.game = Spyfall(JSON: JSON(""))
    }
    
    static func startObservingNotification(_ notification: SessionNotification) {
        if notification == .partyChanged {
            Session.startObservingPartyChangedNotification()
        }
        else if notification == .gameChanged {
            Session.startObservingGameChangedNotification()
        }
    }
    
    static func stopObservingNotification(_ notification: SessionNotification) {
        if notification == .partyChanged {
            Session.stopObservingPartyChangedNotification()
        }
        else if notification == .gameChanged {
            Session.stopObservingGameChangedNotification()
        }
    }
    
    static func startObservingPartyChangedNotification() {
        Session.database.child("sessions/\(Session.code)/\(SessionKey.party.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Session.party = Party(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(SessionNotification.partyChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingPartyChangedNotification() {
        self.database.child("sessions/\(Session.code)/\(SessionKey.party.rawValue)").removeAllObservers()
    }
    
    static func startObservingGameChangedNotification() {
        self.database.child("sessions/\(Session.code)/\(SessionKey.game.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Session.game = Spyfall(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(SessionNotification.gameChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingGameChangedNotification() {
        Session.database.child("sessions/\(Session.code)/\(SessionKey.game.rawValue)").removeAllObservers()
    }
    
    // MARK: - Utility Methods
    
    static func randomCode() -> String {
        var randomCode = ""
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for _ in 1...4 {
            let randomIndex = Int(arc4random())
            
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])
            
            randomCode += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }
        
        return randomCode
    }
    
}
