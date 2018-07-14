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

    // MARK: - Remote Properties

    var hostId: String = Partybox.value.none

    var gameId: String = Partybox.value.none

    var guests: OrderedSet<PartyGuest> = OrderedSet<PartyGuest>()

    var game: PartyGame = PartyGame()

    // MARK: - Local Properties

    var wannabe: Wannabe {
        return self.game as! Wannabe
    }

    // MARK: - Construction Functions

    static func construct(name: String) -> Party {
        let party = Party()
        // Identifiable Properties
        party.id = Party.randomPartyId()
        // Event Properties
        party.name = name
        party.timestamp = Partybox.value.zero
        party.userId = Partybox.value.none
        // Party Properties
        party.hostId = Partybox.value.none
        party.gameId = Party.randomPartyGameId()
        party.guests = OrderedSet<PartyGuest>()
        party.game = PartyGame()
        return party
    }

    static func construct(id: String) -> Party {
        let party = Party()
        // Identifiable Properties
        party.id = id
        // Event Properties
        party.name = Partybox.value.none
        party.timestamp = Partybox.value.zero
        party.userId = Partybox.value.none
        // Party Properties
        party.hostId = Partybox.value.none
        party.gameId = Party.randomPartyGameId()
        party.guests = OrderedSet<PartyGuest>()
        party.game = PartyGame()
        return party
    }

    // MARK: - JSON Functions

    private func merge(json: JSON) {
        for (key, value) in json {
            // Identifiable Properties
            if key == PartyKey.id.rawValue {
                self.id = value.stringValue
            }

            // Event Properties
            if key == PartyKey.name.rawValue {
                self.name = value.stringValue
            }

            if key == PartyKey.timestamp.rawValue {
                self.timestamp = value.intValue
            }

            // Party Properties
            if key == PartyKey.hostId.rawValue {
                self.hostId = value.stringValue
            }

            if key == PartyKey.gameId.rawValue {
                self.gameId = value.stringValue
            }

            if key == PartyKey.guests.rawValue {
                for (_, json) in value {
                    let guest = PartyGuest.construct(json: json)
                    self.guests.add(guest)
                }
            }

            if key == PartyGame.wannabeId {
                self.game = Wannabe.construct(partyId: self.id)
            }
        }
    }

    // MARK: - Party Functions

    func start(name: String, callback: @escaping (_ error: String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            self.hostId = id
            self.userId = id

            let guest = PartyGuest.construct(id: id, name: name)

            let values = [
                PartyKey.id.rawValue: self.id,
                PartyKey.name.rawValue: self.name,
                PartyKey.timestamp.rawValue: ServerValue.timestamp(),
                PartyKey.hostId.rawValue: self.hostId,
                PartyKey.gameId.rawValue: self.gameId,
                PartyKey.guests.rawValue: [
                    guest.id: [
                        PartyGuestKey.id.rawValue: guest.id,
                        PartyGuestKey.name.rawValue: guest.name,
                        PartyGuestKey.points.rawValue: guest.points
                    ]
                ]
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
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

    func end(callback: @escaping (_ error: String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func enter(name: String, callback: @escaping (_ error: String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            self.userId = id

            let guest = PartyGuest.construct(id: id, name: name)

            let values = [
                guest.id: [
                    PartyGuestKey.id.rawValue: guest.id,
                    PartyGuestKey.name.rawValue: guest.name,
                    PartyGuestKey.points.rawValue: guest.points
                ]
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your party\n\nPlease try again")
                    return
                }

                path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

                Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
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

    func exit(callback: @escaping (_ error: String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)/\(self.userId)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Database Functions

    func remove(guestId: String, callback: @escaping (_ error: String?) -> Void) {
        let values = [guestId: Partybox.value.null]

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

        Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func change(hostId: String, callback: @escaping (_ error: String?) -> Void) {
        let values = [PartyKey.hostId.rawValue: hostId]

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func change(name: String, hostId: String, callback: @escaping (_ error: String?) -> Void) {
        let values = [PartyKey.name.rawValue: name, PartyKey.hostId.rawValue: hostId]

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func change(gameId: String, callback: @escaping (_ error: String?) -> Void) {
        let values = [PartyKey.gameId.rawValue: gameId]

        let path = "\(PartyboxKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    private func startObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.name = data

            let name = Notification.Name(PartyNotification.nameChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.hostId.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.hostId = data

            let name = Notification.Name(PartyNotification.hostIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.gameId.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.gameId = data

            let name = Notification.Name(PartyNotification.gameIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

        Partybox.firebase.database.child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let guest = PartyGuest.construct(json: json)

            self.guests.add(guest)

            let name = Notification.Name(PartyNotification.guestAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

        Partybox.firebase.database.child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let guest = PartyGuest.construct(json: json)

            self.guests.add(guest)

            let name = Notification.Name(PartyNotification.guestChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

        Partybox.firebase.database.child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let guest = PartyGuest.construct(json: json)

            self.guests.remove(guest)

            let name = Notification.Name(PartyNotification.guestRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    private func stopObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.hostId.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.gameId.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()
    }

    // MARK: - Utility Functions

    private static func randomPartyId() -> String {
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

    private static func randomPartyGameId() -> String {
        return "C2D4V"
    }
    
}
