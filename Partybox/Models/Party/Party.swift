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
    
    // MARK: - Property Keys
        
    case details
        
    case people

}

enum PartyNotification: String {
    
    // MARK: - Notification Types
    
    case hostChanged = "Party/hostChanged"
    
    case detailsChanged = "Party/detailsChanged"
    
    case peopleChanged = "Party/peopleChanged"
    
}

enum PartyStatus: String {

    // MARK: - Status Types

    case waiting = "Waiting"

}

class Party {

    // MARK: - Shared Instance

    static var current: Party = Party()
    
    // MARK: - Instance Properties
    
    var details: PartyDetails
    
    var people: PartyPeople

    private var database: DatabaseReference

    // MARK: - Initialization Functions
    
    init() {
        self.details = PartyDetails()
        self.people = PartyPeople()
        self.database = Database.database().reference()
    }

    init(JSON: JSON) {
        self.details = PartyDetails(JSON: JSON[PartyKey.details.rawValue])
        self.people = PartyPeople(JSON: JSON[PartyKey.people.rawValue])
        self.database = Database.database().reference()
    }

    // MARK: - Database Functions

    func start(callback: @escaping (String?) -> Void) {
        let id = self.randomId()
        var path = "\(DatabaseKey.parties.rawValue)/\(id)"

        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            let person = PartyPerson()
            path = "\(DatabaseKey.parties.rawValue)/\(id)/\(PartyKey.people.rawValue)"
            person.id = self.database.child(path).childByAutoId().key
            person.name = User.current.name

            User.current.id = person.id

            self.details.id = id
            self.details.hostId = person.id

            path = "\(DatabaseKey.parties.rawValue)/\(id)"
            let values = [
                PartyKey.details.rawValue: [
                    PartyDetailsKey.id.rawValue: self.details.id,
                    PartyDetailsKey.name.rawValue: self.details.name,
                    PartyDetailsKey.status.rawValue: self.details.status,
                    PartyDetailsKey.value.rawValue: self.details.value,
                    PartyDetailsKey.hostId.rawValue: self.details.hostId,
                    PartyDetailsKey.timestamp.rawValue: ServerValue.timestamp()
                ],
                PartyKey.people.rawValue: [
                    person.id: [
                        PartyPersonKey.id.rawValue: person.id,
                        PartyPersonKey.name.rawValue: person.name,
                        PartyPersonKey.status.rawValue: person.status,
                        PartyPersonKey.value.rawValue: person.value,
                        PartyPersonKey.points.rawValue: person.points
                    ]
                ]
            ]

            self.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your party\n\nPlease try again")
                    return
                }

                self.startObservingChanges()
                callback(nil)
            })
        })
    }

    func join(callback: @escaping (String?) -> Void) {
        let id = self.details.id
        var path = "\(DatabaseKey.parties.rawValue)/\(id)"

        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            let person = PartyPerson()
            path = "\(DatabaseKey.parties.rawValue)/\(id)/\(PartyKey.people.rawValue)"
            person.id = self.database.child(path).childByAutoId().key
            person.name = User.current.name

            User.current.id = person.id

            path = "\(DatabaseKey.parties.rawValue)/\(id)/\(PartyKey.people.rawValue)"
            let values = [
                person.id: [
                    PartyPersonKey.id.rawValue: person.id,
                    PartyPersonKey.name.rawValue: person.name,
                    PartyPersonKey.status.rawValue: person.status,
                    PartyPersonKey.value.rawValue: person.value,
                    PartyPersonKey.points.rawValue: person.points
                ]
            ]

            self.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your party\n\nPlease try again")
                    return
                }

                self.startObservingChanges()
                callback(nil)
            })
        })
    }

    func end(callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        if self.people.count > 1 {
            path += "/\(PartyKey.people.rawValue)/\(User.current.name)"
        }

        self.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            if error != nil {
                callback("We ran into a problem while ending your party\n\nPlease try again")
                return
            }

            self.stopObservingChanges()
            callback(nil)
        })
    }

    func setName(_ name: String, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"
        let values = [PartyDetailsKey.name.rawValue: name]

        self.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func setHostId(_ id: String, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"
        let values = [PartyDetailsKey.hostId.rawValue: id]

        self.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func removePerson(_ person: PartyPerson, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)/\(person.id)"

        self.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    private func startObservingChanges() {
        self.startObservingHostChanges()
        self.startObservingDetailsChanges()
        self.startObservingPeopleChanges()
    }

    private func stopObservingChanges() {
        self.stopObservingHostChanges()
        self.stopObservingDetailsChanges()
        self.stopObservingPeopleChanges()
    }

    private func startObservingHostChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostId.rawValue)"

        self.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let hostId = snapshot.value as? String else {
                return
            }

            self.details.hostId = hostId

            let name = Notification.Name(PartyNotification.hostChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }

    private func stopObservingHostChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostId.rawValue)"

        self.database.child(path).removeAllObservers()
    }

    private func startObservingDetailsChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"

        self.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }

            let detailsJSON = JSON(snapshotJSON)

            self.details = PartyDetails(JSON: detailsJSON)

            let name = Notification.Name(PartyNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }

    private func stopObservingDetailsChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"

        self.database.child(path).removeAllObservers()
    }

    private func startObservingPeopleChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)"

        self.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }

            let peopleJSON = JSON(snapshotJSON)

            self.people = PartyPeople(JSON: peopleJSON)

            let name = Notification.Name(PartyNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }

    private func stopObservingPeopleChanges() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)"

        self.database.child(path).removeAllObservers()
    }

    // MARK: - Utility Functions

    private func randomId() -> String {
        var id = ""

        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        for _ in 1...5 {
            let randomIndex = Int(arc4random())

            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])

            id += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }

        return id
    }
    
}
