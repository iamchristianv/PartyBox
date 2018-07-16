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

class Wannabe: PartyGame {
    
    // MARK: - Remote Properties

    var actionId: String = Partybox.value.none

    var wannabeId: String = Partybox.value.none

    var players: OrderedSet<WannabePlayer> = OrderedSet<WannabePlayer>()

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    // MARK: - Construction Functions

    static func construct(partyId: String) -> Wannabe {
        let wannabe = Wannabe()
        // Identifiable Properties
        wannabe.id = PartyGame.wannabeId
        // Event Properties
        wannabe.name = "Wannabe"
        wannabe.timestamp = Partybox.value.zero
        wannabe.userId = Partybox.value.none
        // Party Game Properties
        wannabe.partyId = partyId
        wannabe.summary = "Wannabe Summary"
        wannabe.instructions = "Wannabe Instructions"
        // Wannabe Properties
        wannabe.actionId = Partybox.value.none
        wannabe.wannabeId = Partybox.value.none
        wannabe.players = OrderedSet<WannabePlayer>()
        wannabe.cards = OrderedSet<WannabeCard>()
        return wannabe
    }

    // MARK: - JSON Functions

    private func merge(json: JSON) {
        for (key, value) in json {
            if key == WannabeKey.id.rawValue {
                self.id = value.stringValue
            }

            if key == WannabeKey.name.rawValue {
                self.name = value.stringValue
            }

            if key == WannabeKey.timestamp.rawValue {
                self.timestamp = value.intValue
            }

            if key == WannabeKey.actionId.rawValue {
                self.actionId = value.stringValue
            }

            if key == WannabeKey.wannabeId.rawValue {
                self.wannabeId = value.stringValue
            }

            if key == WannabeKey.players.rawValue {
                for (_, json) in value {
                    let player = WannabePlayer.construct(json: json)
                    self.players.add(player)
                }
            }

            if key == WannabeKey.cards.rawValue {
                for (_, json) in value {
                    let card = WannabeCard.construct(json: json)
                    self.cards.add(card)
                }
            }
        }
    }
    
    // MARK: - Wannabe Functions

    func start(name: String, callback: @escaping (_ error: String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            self.userId = id

            let player = WannabePlayer.construct(id: id, name: name)

            let values = [
                WannabeKey.id.rawValue: self.id,
                WannabeKey.name.rawValue: self.name,
                WannabeKey.timestamp.rawValue: ServerValue.timestamp(),
                WannabeKey.actionId.rawValue: self.actionId,
                WannabeKey.wannabeId.rawValue: self.wannabeId,
                WannabeKey.players.rawValue: [
                    player.id: [
                        WannabePlayerKey.id.rawValue: player.id,
                        WannabePlayerKey.name.rawValue: player.name,
                        WannabePlayerKey.voteId.rawValue: player.voteId,
                        WannabePlayerKey.points.rawValue: player.points
                    ]
                ]
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your game\n\nPlease try again")
                    return
                }

                self.startObservingChanges()

                callback(nil)
            })
        })
    }

    func end(callback: @escaping (_ error: String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func enter(name: String, callback: @escaping (_ error: String?) -> Void) {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find the game\n\nPlease try again")
                return
            }

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            self.userId = id

            let player = WannabePlayer.construct(id: id, name: name)

            let values = [
                player.id: [
                    WannabePlayerKey.id.rawValue: player.id,
                    WannabePlayerKey.name.rawValue: player.name,
                    WannabePlayerKey.voteId.rawValue: player.voteId,
                    WannabePlayerKey.points.rawValue: player.points
                ]
            ] as [String: Any]

            path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game\n\nPlease try again")
                    return
                }

                path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)"

                Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
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

    func exit(callback: @escaping (_ error: String?) -> Void) {
        self.stopObservingChanges()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)/\(self.userId)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Database Functions

    func update(path: String, value: [String: Any], callback: @escaping (_ error: String?) -> Void) {
        Partybox.firebase.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    private func startObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.actionId.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.actionId = data

            let name = Notification.Name(WannabeNotification.actionIdChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

        Partybox.firebase.database.child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let player = WannabePlayer.construct(json: json)

            self.players.add(player)

            let name = Notification.Name(WannabeNotification.playerAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

        Partybox.firebase.database.child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let player = WannabePlayer.construct(json: json)

            self.players.add(player)

            let name = Notification.Name(WannabeNotification.playerChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

        Partybox.firebase.database.child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let player = WannabePlayer.construct(json: json)

            self.players.remove(player)

            let name = Notification.Name(WannabeNotification.playerRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    private func stopObservingChanges() {
        var path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.actionId.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(PartyboxKey.parties.rawValue)/\(self.partyId)/\(self.id)/\(WannabeKey.players.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()
    }
    
}
