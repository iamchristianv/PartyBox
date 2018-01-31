//
//  Session.swift
//  Partybox
//
//  Created by Christian Villa on 1/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum SessionKey: String {
    
    case party
    
    case game
    
}

enum SessionNotification: String {
        
    case partyDetailsChanged
    
    case partyPeopleChanged
    
    case gameDetailsChanged
    
    case gamePeopleChanged
    
}

class Session {
    
    // MARK: - User Properties
    
    static var userName: String = ""
    
    static var userIsHost: Bool = false
    
    // MARK: - Session Properties
    
    static var id: String = ""
    
    static var party: Party = Party()
    
    static var game: Game = Wannabe(JSON: JSON(""))
    
    // MARK: - JSON Functions
    
    static func toJSON() -> [String: Any] {
        let JSON = [
            Session.id: [
                SessionKey.party.rawValue: Session.party.toJSON(),
                SessionKey.game.rawValue: Session.game.toJSON()
            ]
        ]

        return JSON
    }
    
    // MARK: - Database Functions
    
    static func start(partyName: String, personName: String, callback: @escaping (String?) -> Void) {
        let id = Session.randomId()
        
        Reference.child(id).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let inviteCodeUsed = snapshot.exists()
            
            if inviteCodeUsed {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            Session.userName = personName
            Session.userIsHost = true
            
            Session.id = id
            
            Session.party.details.name = partyName
            Session.party.details.hostName = personName
            
            let person = PartyPerson(name: personName)
            Session.party.people.add(person)
            
            Reference.updateChildValues(Session.toJSON())

            callback(nil)
        })
    }
    
    static func start(id: String, personName: String, callback: @escaping (String?) -> Void) {
        let path = id
        
        Reference.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let idNotUsed = !snapshot.exists()
            
            if idNotUsed {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            var path = "\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)/\(personName)"
            let personNameUsed = snapshot.hasChild(path)
            
            if personNameUsed {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            guard let _ = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            Session.userName = personName
            Session.userIsHost = false
            
            Session.id = id
            
            let person = PartyPerson(name: personName)
            Session.party.people.add(person)
            
            path = "\(Session.id)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)"
            Reference.child(path).updateChildValues(person.toJSON())
            
            callback(nil)
        })
    }
    
    static func end() {
        var path = "\(Session.id)"
        
        if Session.party.people.count > 1 {
            path += "/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)/\(Session.userName)"
        }
        
        Reference.child(path).removeValue()
    }
    
    // MARK: - Database Functions
        
    static func startSynchronizing() {
        self.party.startSynchronizing()
    }
    
    static func stopSynchronizing() {
        self.party.stopSynchronizing()
    }
    
    // MARK: - Notification Functions
    
    static func startObservingChanges() {
        var name = Notification.Name(PartyNotification.detailsChanged.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(partyDetailsChanged), name: name, object: nil)
        
        name = Notification.Name(PartyNotification.peopleChanged.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(partyPeopleChanged), name: name, object: nil)
        
        self.party.startObservingChanges()
    }
    
    static func stopObservingChanges() {
        var name = Notification.Name(PartyNotification.detailsChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        name = Notification.Name(PartyNotification.peopleChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        self.party.stopObservingChanges()
    }
    
    @objc static func partyDetailsChanged() {
        NotificationCenter.default.post(name: Notification.Name(SessionNotification.partyDetailsChanged.rawValue), object: nil)
    }
    
    @objc static func partyPeopleChanged() {
        NotificationCenter.default.post(name: Notification.Name(SessionNotification.partyPeopleChanged.rawValue), object: nil)
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
    
    // MARK: - Timer Methods
    
//    static func startCountdown(seconds: Int) {
//        Session.timer.invalidate()
//        
//        Session.secondsRemaining = seconds
//
//        Session.timer = Timer.scheduledTimer(timeInterval: 1.0,
//                                           target: self,
//                                           selector: #selector(Session.updateCountdown),
//                                           userInfo: nil,
//                                           repeats: true)
//    }
//
//    @objc static func updateCountdown() {
//        Session.secondsRemaining -= 1
//
//        NotificationCenter.default.post(name: Notification.Name(PartyNotification.timerChanged.rawValue), object: nil)
//
//        if Session.secondsRemaining == 0 {
//            Session.timer.invalidate()
//        }
//    }
    
}
