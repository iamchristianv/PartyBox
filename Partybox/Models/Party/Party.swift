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
    
    case inviteCode = "inviteCode"
    
    case name = "name"
    
}

class Party {
    
    // MARK: - Database
    
    static let database: DatabaseReference = Database.database().reference().child(String(describing: Party.self))
    
    // MARK: - Properties
    
    var inviteCode: String
    
    var name: String
    
    var people: People
    
    var game: Game?
    
    // MARK: - Initialization
    
    init(inviteCode: String, name: String) {
        self.inviteCode = inviteCode
        self.name = name
        self.people = People()
    }
    
    init(inviteCode: String, JSON: [String: Any]) {
        self.inviteCode = inviteCode
        self.name = JSON[PartyKey.name.rawValue] as? String ?? ""
        self.people = People()
    }
    
    // MARK: - Database
    
    static func start(partyName: String, personName: String, callback: @escaping (Party?, Person?, String?) -> Void) {
        let inviteCode = Party.randomInviteCode()
        
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (partySnapshot) in
            
            let inviteCodeUsed = partySnapshot.exists()
            
            if inviteCodeUsed {
                callback(nil, nil, "We encountered an error while starting your party\n\nPlease try again")
                return
            }
            
            let person = Person(name: personName, isHost: true)
            let party = Party(inviteCode: inviteCode, name: partyName)
            
            party.people.add(person)
            
            let partyValue = [
                party.inviteCode: [
                    PartyKey.name.rawValue: party.name
                ]
            ] as [String: Any]
            
            Party.database.updateChildValues(partyValue)
            
            let peopleValue = [
                party.inviteCode: [
                    person.name: [
                        PersonKey.isHost.rawValue: person.isHost,
                        PersonKey.points.rawValue: person.points,
                        PersonKey.emoji.rawValue:  person.emoji
                    ]
                ]
            ] as [String: Any]
            
            People.database.updateChildValues(peopleValue)
            
            let gameValue = [
                party.inviteCode: [
                    GameKey.name.rawValue: "Spyfall"
                ]
            ]
            
            Game.database.updateChildValues(gameValue)
            
            callback(party, person, nil)
        })
    }
    
    static func join(inviteCode: String, personName: String, callback: @escaping (Party?, Person?, String?) -> Void) {
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (partySnapshot) in
            
            let inviteCodeNotUsed = !partySnapshot.exists()
            
            if inviteCodeNotUsed {
                callback(nil, nil, "We were unable to find a party with your invite code\n\nPlease try again")
                return
            }
            
            guard let JSON = partySnapshot.value as? [String: Any] else {
                callback(nil, nil, "We encountered an error while joining your party\n\nPlease try again")
                return
            }
            
            People.database.child(inviteCode).child(personName).observeSingleEvent(of: .value, with: {
                (peopleSnapshot) in
                
                let personNameUsed = peopleSnapshot.exists()
                
                if personNameUsed {
                    callback(nil, nil, "Someone at the party already has your name\n\nPlease try again")
                    return
                }
                
                let person = Person(name: personName, isHost: false)
                let party = Party(inviteCode: inviteCode, JSON: JSON)
                
                party.people.add(person)
                
                let personValue = [
                    PersonKey.isHost.rawValue: person.isHost,
                    PersonKey.points.rawValue: person.points,
                    PersonKey.emoji.rawValue:  person.emoji
                ] as [String : Any]
                
                People.database.child(party.inviteCode).child(person.name).setValue(personValue)
                
                callback(party, person, nil)
            })
        })
    }
    
    func end() {
        People.database.child(self.inviteCode).removeValue()
        Party.database.child(self.inviteCode).removeValue()
    }
    
    // MARK: - Utility
    
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
