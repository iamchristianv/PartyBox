//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import FirebaseDatabase
import Foundation

enum PartyKey: String {
    
    case inviteCode
    
    case name
    
}

class Party {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: Party.self)
    
    static let database: DatabaseReference = Database.database().reference().child(Party.name)
    
    // MARK: - Instance Properties
    
    var inviteCode: String
    
    var name: String
    
    var people: People
    
    var game: Game
    
    // MARK: - Initialization Methods
    
    init(inviteCode: String, partyName: String, personName: String, isHost: Bool) {
        self.inviteCode = inviteCode
        self.name = partyName
        
        let me = Person(name: personName, isHost: isHost)
        self.people = People(me: me)
        
        self.game = Game(name: "Spyfall")
    }
    
    init(inviteCode: String, JSON: [String: Any], personName: String, isHost: Bool) {
        self.inviteCode = inviteCode
        self.name = JSON[PartyKey.name.rawValue] as? String ?? ""
        
        let me = Person(name: personName, isHost: isHost)
        self.people = People(me: me)
        
        self.game = Game(name: "Spyfall")
    }
    
    // MARK: - Party Methods
    
    static func start(partyName: String, personName: String, callback: @escaping (Party?, String?) -> Void) {
        let inviteCode = Party.randomInviteCode()
        
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (partySnapshot) in
            
            let inviteCodeUsed = partySnapshot.exists()
            
            if inviteCodeUsed {
                callback(nil, "We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            let party = Party(inviteCode: inviteCode, partyName: partyName, personName: personName, isHost: true)
            
            let partyValue = [
                PartyKey.name.rawValue: party.name
            ] as [String: Any]
            
            Party.database.child(party.inviteCode).updateChildValues(partyValue)
            
            let peopleValue = [
                party.people.me.name: [
                    PersonKey.isHost.rawValue: party.people.me.isHost,
                    PersonKey.points.rawValue: party.people.me.points,
                    PersonKey.emoji.rawValue:  party.people.me.emoji
                ]
            ] as [String: Any]
            
            People.database.child(party.inviteCode).updateChildValues(peopleValue)
            
            let gameValue = [
                GameKey.name.rawValue: party.game.name
            ] as [String: Any]
            
            Game.database.child(party.inviteCode).updateChildValues(gameValue)
            
            callback(party, nil)
        })
    }
    
    static func join(inviteCode: String, personName: String, callback: @escaping (Party?, String?) -> Void) {
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (partySnapshot) in
            
            let inviteCodeUsed = partySnapshot.exists()
            
            if !inviteCodeUsed {
                callback(nil, "We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            guard let partyJSON = partySnapshot.value as? [String: Any] else {
                callback(nil, "We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            People.database.child(inviteCode).child(personName).observeSingleEvent(of: .value, with: {
                (peopleSnapshot) in
                
                let personNameUsed = peopleSnapshot.exists()
                
                if personNameUsed {
                    callback(nil, "Someone at the party already has your name\n\nPlease try again")
                    return
                }
                
                guard let peopleJSON = peopleSnapshot.value as? [String: Any] else {
                    callback(nil, "We ran into a problem while joining your party\n\nPlease try again")
                    return
                }
                
                let party = Party(inviteCode: inviteCode, JSON: JSON, personName: personName, isHost: false)
                
                let peopleValue = [
                    party.people.me.name: [
                        PersonKey.isHost.rawValue: party.people.me.isHost,
                        PersonKey.points.rawValue: party.people.me.points,
                        PersonKey.emoji.rawValue:  party.people.me.emoji
                    ]
                ] as [String: Any]
                
                People.database.child(party.inviteCode).updateChildValues(peopleValue)

                callback(party, nil)
            })
        })
    }
    
    static func end(inviteCode: String) {
        Party.database.child(inviteCode).removeValue()
        People.database.child(inviteCode).removeValue()
        Game.database.child(inviteCode).removeValue()
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
