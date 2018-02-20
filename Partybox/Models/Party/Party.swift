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
    
    // MARK: - Shared Instance
    
    static var current: Party = Party()
    
    // MARK: - Instance Properties
    
    var details: PartyDetails = PartyDetails(JSON: JSON(""))
    
    var people: PartyPeople = PartyPeople(JSON: JSON(""))
        
    // MARK: - Database Properties
    
    var json: [String: Any] {
        let json = [
            Party.current.details.id: [
                PartyKey.details.rawValue: Party.current.details.json,
                PartyKey.people.rawValue: Party.current.people.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Database Functions
    
    func start(userName: String, partyName: String, callback: @escaping (String?) -> Void) {
        Party.current = Party()
        
        let id = Party.current.randomId()
        let path = "\(ReferenceKey.parties.rawValue)/\(id)"
        
        Reference.child(path).observeSingleEvent(of: .value, with: {
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
            
            Reference.child(path).updateChildValues(value)
            
            Party.current.startObservingChanges()
            
            callback(nil)
        })
    }
    
    func start(userName: String, partyId: String, callback: @escaping (String?) -> Void) {
        Party.current = Party()
        
        let id = partyId
        let path = "\(ReferenceKey.parties.rawValue)/\(id)"
        
        Reference.child(path).observeSingleEvent(of: .value, with: {
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
            
            let person = PartyPerson(name: userName, JSON: JSON(""))
            
            Party.current.people.add(person)
            
            let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
            let value = person.json
            
            Reference.child(path).updateChildValues(value)
            
            Party.current.startObservingChanges()
            
            callback(nil)
        })
    }
    
    func end() {
        var path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)"
        
        if Party.current.people.count > 1 {
            path += "/\(PartyKey.people.rawValue)/\(User.current.name)"
        }
        
        Party.current.stopObservingChanges()
        
        Reference.child(path).removeValue()
        
        Party.current = Party()
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        var path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.details = PartyDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.detailsChanged.rawValue)
            
            NotificationCenter.default.post(name: name, object: nil)
        })
        
        path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.people = PartyPeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.peopleChanged.rawValue)
            
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingChanges() {
        var path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.child(path).removeAllObservers()
        
        path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.child(path).removeAllObservers()
    }
    
    // MARK: - Utility Functions
    
    func randomId() -> String {
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
