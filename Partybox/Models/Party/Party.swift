//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyKey: String {
    
    // MARK: - Database Keys
        
    case details
        
    case people
        
}

enum PartyNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Party/PartyDetails/detailsChanged"
    
    case peopleChanged = "Party/PartyPeople/peopleChanged"
    
}

class Party {
    
    // MARK: - Instance Properties
    
    static var details: PartyDetails = PartyDetails(JSON: JSON(""))
    
    static var people: PartyPeople = PartyPeople(JSON: JSON(""))
        
    // MARK: - Database Properties
    
    static var json: [String: Any] {
        let json = [
            Party.details.id: [
                PartyKey.details.rawValue: Party.details.json,
                PartyKey.people.rawValue: Party.people.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Database Functions
    
    static func start(userName: String, partyName: String, callback: @escaping (String?) -> Void) {
        let id = Party.randomId()
        let path = "\(DatabaseKey.parties.rawValue)/\(id)"
        
        database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            User.name = userName
            
            Party.details.id = id
            Party.details.name = partyName
            Party.details.hostName = userName
            Party.people.add(PartyPerson(name: userName, JSON: JSON("")))
            
            let path = "\(DatabaseKey.parties.rawValue)"
            database.child(path).updateChildValues(Party.json)
            
            self.startObservingChanges()
            callback(nil)
        })
    }
    
    static func start(userName: String, partyId: String, callback: @escaping (String?) -> Void) {
        let id = partyId
        let path = "\(DatabaseKey.parties.rawValue)/\(id)"
        
        database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            if snapshot.hasChild("\(PartyKey.people.rawValue)/\(userName)") {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            User.name = userName
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            let partyJSON = JSON(snapshotJSON)
            Party.details = PartyDetails(JSON: JSON(partyJSON[PartyKey.details.rawValue]))
            Party.people = PartyPeople(JSON: JSON(partyJSON[PartyKey.people.rawValue]))
            let person = PartyPerson(name: userName, JSON: JSON(""))
            Party.people.add(person)
            
            let path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.people.rawValue)"
            database.child(path).updateChildValues(person.json)
            
            self.startObservingChanges()
            callback(nil)
        })
    }
    
    static func end() {
        var path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)"
        
        if Party.people.count > 1 {
            path += "/\(PartyKey.people.rawValue)/\(User.name)"
        }
        
        self.stopObservingChanges()
        database.child(path).removeValue()
    }
    
    // MARK: - Notification Functions
    
    static func startObservingChanges() {
        var path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.details.rawValue)"
        
        database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            self.details = PartyDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
        
        path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.people.rawValue)"
        
        database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            self.people = PartyPeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    static func stopObservingChanges() {
        var path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.details.rawValue)"
        
        database.child(path).removeAllObservers()
        
        path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.people.rawValue)"
        
        database.child(path).removeAllObservers()
    }
    
    // MARK: - Utility Functions
    
    static func randomId() -> String {
        var randomId = ""
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for _ in 1...4 {
            let randomIndex = Int(arc4random())
            
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])
            
            randomId += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }
        
        return randomId
    }
    
}
