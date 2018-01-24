//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum PartyKey: String {
    
    case details
        
    case people
    
    case game
        
}

enum PartyNotification: String {
        
    case partyDetailsChanged
    
    case partyPeopleChanged
    
    case gameDetailsChanged
    
    case gamePeopleChanged
    
    case timerChanged
    
}

class Party {
    
    // MARK: - Class Properties
    
    static let database: DatabaseReference = Database.database().reference().child("parties")
    
    static var userName: String = ""
    
    static var userHost: Bool = false
        
    static var inviteCode: String = ""
    
    static var details: PartyDetails = PartyDetails(JSON: JSON(""))
    
    static var people: PartyPeople = PartyPeople(JSON: JSON(""))
    
    static var game: WannabeGame = WannabeGame(JSON: JSON(""))
    
    static var timer: Timer = Timer()
    
    static var secondsRemaining: Int = 0
    
    // MARK: - JSON Methods
    
    static func toJSON() -> [String: Any] {
        let JSON = [
            Party.inviteCode: [
                PartyKey.details.rawValue: Party.details.toJSON(),
                PartyKey.people.rawValue: Party.people.toJSON(),
                PartyKey.game.rawValue: Party.game.toJSON()
            ]
        ] as [String: Any]
        
        return JSON
    }
    
    // MARK: - Party Methods
    
    static func start(partyName: String, personName: String, callback: @escaping (String?) -> Void) {
        let inviteCode = Party.randomInviteCode()
        
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let codeUsed = snapshot.exists()
            
            if codeUsed {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }
            
            Party.userName = personName
            Party.userHost = true
            Party.inviteCode = inviteCode
            Party.details = PartyDetails(name: partyName, host: personName)
            Party.people = PartyPeople(JSON: JSON(""))
            Party.game = WannabeGame(JSON: JSON(""))
            
            let person = PartyPerson(name: personName)
            Party.people.add(person)
            
            Party.synchronize()
            
            callback(nil)
        })
    }
    
    static func end() {
        Party.database.child(Party.inviteCode).removeValue()
    }
    
    static func join(inviteCode: String, personName: String, callback: @escaping (String?) -> Void) {
        Party.database.child(inviteCode).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let codeUsed = snapshot.exists()
            
            if !codeUsed {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }
            
            let personNameUsed = snapshot.hasChild("\(PartyKey.people.rawValue)/\(personName)")
            
            if personNameUsed {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while joining your party\n\nPlease try again")
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            
            Party.userName = personName
            Party.userHost = false
            Party.inviteCode = inviteCode
            Party.details = PartyDetails(JSON: sessionJSON[PartyKey.details.rawValue])
            Party.people = PartyPeople(JSON: sessionJSON[PartyKey.people.rawValue])
            Party.game = WannabeGame(JSON: sessionJSON[PartyKey.game.rawValue])
            
            let person = PartyPerson(name: personName)
            Party.people.add(person)
            
            Party.database.child("\(Party.inviteCode)/\(PartyKey.people.rawValue)").updateChildValues(person.toJSON())
                                                
            callback(nil)
        })
    }
    
    static func leave() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.people.rawValue)/\(Party.userName)").removeValue()
    }
    
    static func synchronize() {
        Party.database.updateChildValues(Party.toJSON())
    }
    
    // MARK: - Notification Methods
    
    static func startObservingPartyDetailsChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.details.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Party.details = PartyDetails(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(PartyNotification.partyDetailsChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingPartyDetailsChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.details.rawValue)").removeAllObservers()
    }
    
    static func startObservingPartyPeopleChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.people.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Party.people = PartyPeople(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(PartyNotification.partyPeopleChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingPartyPeopleChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.people.rawValue)").removeAllObservers()
    }
    
    static func startObservingGameDetailsChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.game.rawValue)/\(PartyGameKey.details.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Party.game.details = WannabeDetails(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(PartyNotification.gameDetailsChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingGameDetailsChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.game.rawValue)/\(PartyGameKey.details.rawValue)").removeAllObservers()
    }
    
    static func startObservingGamePeopleChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.game.rawValue)/\(PartyGameKey.people.rawValue)").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }
            
            let sessionJSON = JSON(snapshotJSON)
            Party.game.people = WannabePeople(JSON: sessionJSON)
            
            NotificationCenter.default.post(name: Notification.Name(PartyNotification.gamePeopleChanged.rawValue), object: nil)
        })
    }
    
    static func stopObservingGamePeopleChanged() {
        Party.database.child("\(Party.inviteCode)/\(PartyKey.game.rawValue)/\(PartyGameKey.people.rawValue)").removeAllObservers()
    }
    
    // MARK: - Utility Methods
    
    static func randomInviteCode() -> String {
        var randomInviteCode = ""
        
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for _ in 1...4 {
            let randomIndex = Int(arc4random())
            
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])
            
            randomInviteCode += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }
        
        return randomInviteCode
    }
    
    // MARK: - Timer Methods
    
    static func startCountdown(seconds: Int) {
        Party.timer.invalidate()
        
        Party.secondsRemaining = seconds
        
        Party.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(Party.updateCountdown),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc static func updateCountdown() {
        Party.secondsRemaining -= 1
        
        NotificationCenter.default.post(name: Notification.Name(PartyNotification.timerChanged.rawValue), object: nil)
        
        if Party.secondsRemaining == 0 {
            Party.timer.invalidate()
        }
    }
    
}
