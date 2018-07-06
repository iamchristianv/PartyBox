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

class Wannabe {
    
    // MARK: - Instance Properties

    var id: String = Partybox.value.none

    var name: String = Partybox.value.none

    var action: String = Partybox.value.none

    var wannabe: String = Partybox.value.none

    var players: OrderedSet<WannabePlayer> = OrderedSet<WannabePlayer>()

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    private var dataSource: WannabeDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabeDataSource) -> Wannabe {
        let wannabe = Wannabe()
        wannabe.id = "C2D4V"
        wannabe.name = "Wannabe"
        wannabe.action = Partybox.value.none
        wannabe.wannabe = Partybox.value.none
        wannabe.players = OrderedSet<WannabePlayer>()
        wannabe.cards = OrderedSet<WannabeCard>()
        wannabe.dataSource = dataSource
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

            if key == WannabeKey.action.rawValue {
                self.action = value.stringValue
            }

            if key == WannabeKey.wannabe.rawValue {
                self.wannabe = value.stringValue
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

    func start(callback: @escaping ErrorCallback) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            let values = [
                WannabeKey.id.rawValue: self.id,
                WannabeKey.name.rawValue: self.name,
                WannabeKey.action.rawValue: self.action,
                WannabeKey.wannabe.rawValue: self.wannabe
            ] as [String: Any]

            path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your game\n\nPlease try again")
                    return
                }

                callback(nil)
            })
        })
    }

    func end(callback: @escaping ErrorCallback) {
        self.stopObservingChanges()

        let path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func enter(name: String, callback: @escaping ErrorCallback) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a game with your invite code\n\nPlease try again")
                return
            }

            path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

            let id = Partybox.firebase.database.child(path).childByAutoId().key

            let player = WannabePlayer.construct(id: id, name: name)

            let values = [
                player.id: [
                    WannabePlayerKey.id.rawValue: player.id,
                    WannabePlayerKey.name.rawValue: player.name,
                    WannabePlayerKey.vote.rawValue: player.vote,
                    WannabePlayerKey.points.rawValue: player.points
                ]
            ] as [String: Any]

            path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

            Partybox.firebase.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)"

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

    func exit(id: String, callback: @escaping ErrorCallback) {
        self.stopObservingChanges()

        let path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)/\(id)"

        Partybox.firebase.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Database Functions

    func update(path: String, value: [String: Any], callback: @escaping (String?) -> Void) {
        Partybox.firebase.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    private func startObservingChanges() {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.action.rawValue)"

        Partybox.firebase.database.child(path).observe(.value, with: {
            (snapshot) in

            guard let data = snapshot.value as? String else {
                return
            }

            self.action = data

            let name = Notification.Name(WannabeNotification.actionChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

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

        path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

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

        path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

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
        var path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.action.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()

        path = "\(DatabaseKey.parties.rawValue)/\(self.dataSource.wannabePartyId())/\(self.id)/\(WannabeKey.players.rawValue)"

        Partybox.firebase.database.child(path).removeAllObservers()
    }
    
}
