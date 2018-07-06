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

class Party {

    // MARK: - Instance Properties

    var id: String = Partybox.value.none

    var name: String = Partybox.value.none

    var host: String = Partybox.value.none

    var date: Int = Partybox.value.zero

    var guests: OrderedSet<PartyGuest> = OrderedSet<PartyGuest>()

    var wannabe: Wannabe = Wannabe()

    // MARK: - Construction Functions

    static func construct(name: String) -> Party {
        let party = Party()
        party.id = Party.randomPartyId()
        party.name = name
        party.host = Partybox.value.none
        party.date = Partybox.value.zero
        party.guests = OrderedSet<PartyGuest>()
        party.wannabe = Wannabe()
        return party
    }

    static func construct(id: String) -> Party {
        let party = Party()
        party.id = id
        party.name = Partybox.value.none
        party.host = Partybox.value.none
        party.date = Partybox.value.zero
        party.guests = OrderedSet<PartyGuest>()
        party.wannabe = Wannabe()
        return party
    }

    // MARK: - JSON Functions

    private func merge(json: JSON) {
        for (key, value) in json {
            if key == PartyKey.id.rawValue {
                self.id = value.stringValue
            }

            if key == PartyKey.name.rawValue {
                self.name = value.stringValue
            }

            if key == PartyKey.host.rawValue {
                self.host = value.stringValue
            }

            if key == PartyKey.date.rawValue {
                self.date = value.intValue
            }

            if key == PartyKey.guests.rawValue {
                for (_, json) in value {
                    let guest = PartyGuest.construct(json: json)
                    self.guests.add(guest)
                }
            }

            if key == PartyKey.wannabe.rawValue {
                self.wannabe = Wannabe.construct(dataSource: self)
            }
        }
    }

    // MARK: - Party Functions

    func start(callback: @escaping ErrorCallback) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            let values = [
                PartyKey.id.rawValue: self.id,
                PartyKey.name.rawValue: self.name,
                PartyKey.host.rawValue: self.host,
                PartyKey.date.rawValue: ServerValue.timestamp()
            ] as [String: Any]

            path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your party\n\nPlease try again")
                    return
                }

                callback(nil)
            })
        })
    }

    func end(callback: @escaping ErrorCallback) {
        self.stopObservingChanges()

        let path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func enter(name: String, callback: @escaping ErrorCallback) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            let guest = PartyGuest.construct(id: id, name: name)

            let values = [
                guest.id: [
                    PartyGuestKey.id.rawValue: guest.id,
                    PartyGuestKey.name.rawValue: guest.name,
                    PartyGuestKey.points.rawValue: guest.points
                ]
            ] as [String: Any]

            path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your party\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

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

    func leave(id: String, callback: @escaping ErrorCallback) {
        self.stopObservingChanges()

        let path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)/\(id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Database Functions

    func kick(id: String, callback: @escaping ErrorCallback) {
        let value = Partybox.value.null

        let path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)/\(id)"

        Partybox.firebase.database.child(path).setValue(value, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func change(host: String, callback: @escaping ErrorCallback) {
        let value = host

        let path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.host.rawValue)"

        Partybox.firebase.database.child(path).setValue(value, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func change(name: String, host: String, callback: @escaping ErrorCallback) {
        let values = [PartyKey.name.rawValue: name, PartyKey.host.rawValue: host]

        let path = "\(DatabaseKey.parties.rawValue)/\(self.id)"

        Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    private func startObservingChanges() {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.name = data

            let name = Notification.Name(PartyNotification.nameChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.host.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.host = data

            let name = Notification.Name(PartyNotification.hostChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"

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

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"


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

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.guests.rawValue)"


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
        var path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.name.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(PartyKey.host.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(DatabaseKey.parties.rawValue)/\(self.id)/\(DatabaseKey.guests.rawValue)"

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
    
}

extension Party: WannabeDataSource {

    internal func wannabePartyId() -> String {
        return self.id
    }

}
