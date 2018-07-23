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

class Party: Event {

    // MARK: - Properties

    var id: String

    var name: String

    var userId: String

    var hostId: String

    var gameId: String

    var packId: String

    var persons: OrderedSet<PartyPerson> 

    var timestamp: Int

    // MARK: - Initialization Functions

    init(name: String) {
        self.id = Party.randomPartyId()
        self.name = name
        self.hostId = Partybox.value.none
        self.userId = Partybox.value.none
        self.gameId = Partybox.value.none
        self.packId = Partybox.value.none
        self.persons = OrderedSet<PartyPerson>()
        self.timestamp = Partybox.value.zero
    }

    init(id: String) {
        self.id = id
        self.name = Partybox.value.none
        self.hostId = Partybox.value.none
        self.userId = Partybox.value.none
        self.gameId = Partybox.value.none
        self.packId = Partybox.value.none
        self.persons = OrderedSet<PartyPerson>()
        self.timestamp = Partybox.value.zero
    }

    // MARK: - JSON Functions

    func merge(json: JSON) {
        for (key, value) in json {
            if key == PartyKey.id.rawValue {
                self.id = value.stringValue
            }

            if key == PartyKey.name.rawValue {
                self.name = value.stringValue
            }

            if key == PartyKey.hostId.rawValue {
                self.hostId = value.stringValue
            }

            if key == PartyKey.gameId.rawValue {
                self.gameId = value.stringValue
            }

            if key == PartyKey.packId.rawValue {
                self.packId = value.stringValue
            }

            if key == PartyKey.persons.rawValue {
                for (_, json) in value {
                    let person = PartyPerson(json: json)
                    self.persons.add(person)
                }
            }

            if key == PartyKey.timestamp.rawValue {
                self.timestamp = value.intValue
            }
        }
    }

    // MARK: - Party Functions

    func initialize(callback: @escaping (String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            let values = [
                PartyKey.id.rawValue: self.id,
                PartyKey.name.rawValue: self.name,
                PartyKey.hostId.rawValue: self.hostId,
                PartyKey.gameId.rawValue: self.gameId,
                PartyKey.packId.rawValue: self.packId,
                PartyKey.timestamp.rawValue: self.timestamp
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your party\n\nPlease try again")
                    return
                }

                callback(nil)
            })
        })
    }

    func terminate(callback: @escaping (String?) -> Void) {
        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Person Functions

    func createPerson(name: String) -> PartyPerson {
        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)"

        let id = Database.database().reference().child(path).childByAutoId().key

        let person = PartyPerson(id: id, name: name)

        return person
    }

    func insert(person: PartyPerson, callback: @escaping (String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            self.userId = person.id

            var values = [:] as [String: Any]

            path = "\(PartyKey.persons.rawValue)"

            if !snapshot.hasChild(path) {
                values[PartyKey.hostId.rawValue] = person.id
            }

            values[PartyKey.persons.rawValue] = [
                person.id: [
                    PartyPersonKey.id.rawValue: person.id,
                    PartyPersonKey.name.rawValue: person.name,
                    PartyPersonKey.points.rawValue: person.points
                ]
            ]

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your party\n\nPlease try again")
                    return
                }

                path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

                Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
                    (snapshot) in

                    if !snapshot.exists() {
                        callback("We ran into a problem while joining your party\n\nPlease try again")
                        return
                    }

                    guard let data = snapshot.value as? [String: Any] else {
                        callback("We ran into a problem while joining your party\n\nPlease try again")
                        return
                    }

                    let json = JSON(data)

                    self.merge(json: json)

                    self.startObservingChanges()

                    callback(nil)
                })
            })
        })
    }

    func remove(person: PartyPerson, callback: @escaping (String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)/\(self.userId)"

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Action Functions

    func update(path: String, values: [String: Any], callback: @escaping (String?) -> Void) {
        Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    func startObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Database.database().reference().child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.name = data

            let name = Notification.Name(PartyNotification.nameChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.hostId.rawValue)"

        Database.database().reference().child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.hostId = data

            let name = Notification.Name(PartyNotification.hostIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.gameId.rawValue)"

        Database.database().reference().child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.gameId = data

            let name = Notification.Name(PartyNotification.gameIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.packId.rawValue)"

        Database.database().reference().child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.packId = data

            let name = Notification.Name(PartyNotification.packIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson(json: json)

            self.persons.add(person)

            let name = Notification.Name(PartyNotification.personAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson(json: json)

            self.persons.add(person)

            let name = Notification.Name(PartyNotification.personChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson(json: json)

            self.persons.remove(person)

            let name = Notification.Name(PartyNotification.personRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    func stopObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Database.database().reference().child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.hostId.rawValue)"

        Database.database().reference().child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.gameId.rawValue)"

        Database.database().reference().child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.packId.rawValue)"

        Database.database().reference().child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.persons.rawValue)"

        Database.database().reference().child(path).removeAllObservers()
    }

    // MARK: - Utility Functions

    static func randomPartyId() -> String {
        var randomPartyId = ""

        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        for _ in 1...5 {
            let randomIndex = Int(arc4random())
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])

            randomPartyId += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }

        return randomPartyId
    }

    static func randomGameId() -> String {
        let randomIndex = Int(arc4random()) % PartyKey.gameIds().count
        let randomGameId = PartyKey.gameIds()[randomIndex]

        return randomGameId
    }

}
