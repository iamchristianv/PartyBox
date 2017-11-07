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

class Session {
    
    // MARK: - Shared Instance
    
    static var current: Session! = nil
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: Session.self)
    
    static let database: DatabaseReference = Database.database().reference().child(Session.name)
    
    // MARK: - Instance Properties
    
    var personName: String
    
    var inviteCode: String
    
    var party: Party
    
    var people: People
    
    var game: Game
    
    // MARK: - Initialization Methods
    
    init(personName: String, inviteCode: String, party: Party, people: People, game: Game) {
        // for client use
        self.personName = personName
        self.inviteCode = inviteCode
        self.party = party
        self.people = people
        self.game = game
    }
    
    init(personName: String, inviteCode: String, JSON: JSON) {
        // for server use
        self.personName = personName
        self.inviteCode = inviteCode
        self.party = Party(JSON: JSON[Party.name])
        self.people = People(JSON: JSON[People.name])
        self.game = Game(JSON: JSON[Game.name])
    }
    
    func toJSON() -> [String: Any] {
        let JSON = [
            self.inviteCode: [
                Party.name: self.party.toJSON(),
                People.name: self.people.toJSON(),
                Game.name: self.game.toJSON()
            ]
        ]
        
        return JSON
    }
    
    // MARK: - Database Methods
    
    static func start(partyName: String, personName: String, callback: @escaping (String?) -> Void) {
        let inviteCode = Session.randomInviteCode()
        
        Session.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let inviteCodeUsed = snapshot.exists()
            
            if inviteCodeUsed {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            let party = Party(name: partyName)
            Session.database.child(inviteCode).updateChildValues(party.toJSON())
            
            let person = Person(name: personName, isHost: true)
            let people = People(persons: [person])
            Session.database.child(inviteCode).updateChildValues(people.toJSON())
            
            let game = Game(name: "Spyfall")
            Session.database.child(inviteCode).updateChildValues(game.toJSON())
            
            Session.current = Session(personName: personName, inviteCode: inviteCode, party: party, people: people, game: game)
            
            callback(nil)
        })
    }
    
    static func end() {
        Session.database.child(Session.current.inviteCode).removeValue()

        Session.current = nil
    }
    
    static func join(inviteCode: String, personName: String, callback: @escaping (String?) -> Void) {
        Session.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let inviteCodeUsed = snapshot.exists()
            
            if !inviteCodeUsed {
                callback("We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            let personNameUsed = snapshot.hasChild("\(People.name)/\(personName)")
            
            if personNameUsed {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Session.current = Session(personName: personName, inviteCode: inviteCode, JSON: sessionJSON)
            
            let person = Person(name: personName, isHost: false)
            Session.current.people.add(person)
            
            Session.database.child(inviteCode).child(People.name).updateChildValues(person.toJSON())
            
            callback(nil)
        })
    }
    
    static func leave() {
        Session.database.child(Session.current.inviteCode).child(People.name).child(Session.current.personName).removeValue()

        Session.current = nil
    }
    
    // MARK: - Utility Methods
    
    static func randomInviteCode() -> String {
        var inviteCode = ""
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for _ in 1...4 {
            let randomIndex = Int(arc4random())
            
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])
            
            inviteCode += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }
        
        return inviteCode
    }
    
}
