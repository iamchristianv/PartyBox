//
//  Wannabe.swift
//  Partybox
//
//  Created by Christian Villa on 11/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class Wannabe: Activity {

    // MARK: - Properties

    var id: String

    var name: String

    var userId: String

    var partyId: String

    var actionId: String

    var wannabeId: String

    var persons: OrderedSet<WannabePerson>

    var cards: OrderedSet<WannabeCard>

    var timestamp: Int

    var summary: String

    var instructions: String

    // MARK: - Initialization Functions

    init(partyId: String) {
        self.id = "C2D4V"
        self.name = "Wannabe"
        self.userId = Partybox.value.none
        self.partyId = partyId
        self.actionId = Partybox.value.none
        self.wannabeId = Partybox.value.none
        self.persons = OrderedSet<WannabePerson>()
        self.cards = OrderedSet<WannabeCard>()
        self.timestamp = Partybox.value.zero
        self.summary = "Wannabe Summary"
        self.instructions = "Wannabe Instructions"
    }

    // MARK: - JSON Functions

    func merge(json: JSON) {
        for (key, value) in json {
            if key == WannabeKey.id.rawValue {
                self.id = value.stringValue
            }

            if key == WannabeKey.name.rawValue {
                self.name = value.stringValue
            }

            if key == WannabeKey.actionId.rawValue {
                self.actionId = value.stringValue
            }

            if key == WannabeKey.wannabeId.rawValue {
                self.wannabeId = value.stringValue
            }

            if key == WannabeKey.persons.rawValue {
                for (_, json) in value {
                    let person = WannabePerson(json: json)
                    self.persons.add(person)
                }
            }

            if key == WannabeKey.cards.rawValue {
                for (_, json) in value {
                    let card = WannabeCard(json: json)
                    self.cards.add(card)
                }
            }

            if key == WannabeKey.timestamp.rawValue {
                self.timestamp = value.intValue
            }
        }
    }

    // MARK: - Wannabe Functions

    func initialize(callback: @escaping (String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            let values = [
                WannabeKey.id.rawValue: self.id,
                WannabeKey.name.rawValue: self.name,
                WannabeKey.actionId.rawValue: self.actionId,
                WannabeKey.wannabeId.rawValue: self.wannabeId,
                WannabeKey.timestamp.rawValue: ServerValue.timestamp()
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your game\n\nPlease try again")
                    return
                }

                callback(nil)
            })
        })
    }

    func terminate(callback: @escaping (String?) -> Void) {
        let path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Person Functions

    func createPerson(name: String) -> WannabePerson {
        let path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)"

        let id = Database.database().reference().child(path).childByAutoId().key

        let person = WannabePerson(id: id, name: name)

        return person
    }

    func insert(person: WannabePerson, callback: @escaping (String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a game with your invite code\n\nPlease try again")
                return
            }

            self.userId = person.id

            var values = [:] as [String: Any]

            values[WannabeKey.persons.rawValue] = [
                person.id: [
                    WannabePersonKey.id.rawValue: person.id,
                    WannabePersonKey.name.rawValue: person.name,
                    WannabePersonKey.points.rawValue: person.points,
                    WannabePersonKey.voteId.rawValue: person.voteId
                ]
            ]

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game\n\nPlease try again")
                    return
                }

                path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

                Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
                    (snapshot) in

                    if !snapshot.exists() {
                        callback("We ran into a problem while joining your game\n\nPlease try again")
                        return
                    }

                    guard let data = snapshot.value as? [String: Any] else {
                        callback("We ran into a problem while joining your game\n\nPlease try again")
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

    func remove(person: WannabePerson, callback: @escaping (String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)/\(self.userId)"

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
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.actionId.rawValue)"

        Database.database().reference().child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.actionId = data

            let name = Notification.Name(WannabeNotification.actionIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson(json: json)

            self.persons.add(person)

            let name = Notification.Name(WannabeNotification.personAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson(json: json)

            self.persons.add(person)

            let name = Notification.Name(WannabeNotification.personChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)"

        Database.database().reference().child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson(json: json)

            self.persons.remove(person)

            let name = Notification.Name(WannabeNotification.personRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    func stopObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.actionId.rawValue)"

        Database.database().reference().child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.persons.rawValue)"

        Database.database().reference().child(path).removeAllObservers()
    }

}
