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

    var details: WannabeDetails!
    
    var people: WannabePeople!

    var collection: WannabeCollection!

    var pack: WannabePack!

    // MARK: - Construction Functions

    static func construct(party: String) -> Wannabe {
        let wannabe = Wannabe()
        wannabe.details = WannabeDetails.construct(party: party, dataSource: wannabe)
        wannabe.people = WannabePeople.construct(dataSource: wannabe)
        wannabe.collection = WannabeCollection.construct(dataSource: wannabe, packDataSource: wannabe)
        wannabe.pack = WannabePack.construct(dataSource: wannabe)
        return wannabe
    }
    
    // MARK: - Wannabe Functions

    func start(user: User, callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            let person = WannabePerson.construct(name: user.name)

            let values = [
                WannabeKey.details.rawValue: [
                    WannabeDetailsKey.id.rawValue: self.details.id,
                    WannabeDetailsKey.name.rawValue: self.details.name,
                    WannabeDetailsKey.status.rawValue: self.details.status,
                    WannabeDetailsKey.rounds.rawValue: self.details.rounds,
                    WannabeDetailsKey.card.rawValue: [
                        WannabeCardKey.hint.rawValue: self.details.card.hint,
                        WannabeCardKey.action.rawValue: self.details.card.action
                    ],
                    WannabeDetailsKey.wannabe.rawValue: self.details.wannabe
                ],
                WannabeKey.people.rawValue: [
                    person.name: [
                        WannabePersonKey.name.rawValue: person.name,
                        WannabePersonKey.points.rawValue: person.points,
                        WannabePersonKey.vote.rawValue: person.vote
                    ]
                ]
            ]

            path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your game\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

                Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
                    (snapshot) in

                    if !snapshot.exists() {
                        callback("We ran into a problem while starting your game\n\nPlease try again")
                        return
                    }

                    guard let data = snapshot.value as? [String: Any] else {
                        callback("We ran into a problem while starting your game\n\nPlease try again")
                        return
                    }

                    let json = JSON(data)

                    self.details = WannabeDetails.construct(json: json, dataSource: self)
                    self.details.startObservingChanges()

                    self.people = WannabePeople.construct(json: json, dataSource: self)
                    self.people.startObservingChanges()

                    callback(nil)
                })
            })
        })
    }

    func leave(user: User, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func join(user: User, callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a game with your invite code\n\nPlease try again")
                return
            }

            let person = WannabePerson.construct(name: user.name)

            let values = [
                person.name: [
                    WannabePersonKey.name.rawValue: person.name,
                    WannabePersonKey.points.rawValue: person.points,
                    WannabePersonKey.vote.rawValue: person.vote
                ]
            ]

            path = "\(DatabaseKey.games.rawValue)/\(self.details.party)/\(WannabeKey.people.rawValue)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.games.rawValue)/\(self.details.party)"

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

                    self.details = WannabeDetails.construct(json: json, dataSource: self)
                    self.details.startObservingChanges()

                    self.people = WannabePeople.construct(json: json, dataSource: self)
                    self.people.startObservingChanges()

                    callback(nil)
                })
            })
        })
    }

    func end(user: User, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.games.rawValue)/\(self.details.party)/\(WannabeKey.people.rawValue)/\(user.name)"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }
    
}

extension Wannabe: WannabeDetailsDataSource {

    // MARK: - Wannabe Details Data Source Functions

    internal func wannabeDetailsPath() -> String {
        return "\(DatabaseKey.games.rawValue)/\(self.details.party)/\(WannabeKey.details.rawValue)"
    }

}

extension Wannabe: WannabePeopleDataSource {

    // MARK: - Wannabe People Data Source Functions

    internal func wannabePeoplePath() -> String {
        return "\(DatabaseKey.games.rawValue)/\(self.details.party)/\(WannabeKey.people.rawValue)"
    }

}

extension Wannabe: WannabeCollectionDataSource {

    // MARK: - Wannabe Collection Data Source Functions

    internal func wannabeCollectionPath() -> String {
        return "\(DatabaseKey.setups.rawValue)/\(SetupKey.games.rawValue)/\(self.details.party)/\(SetupKey.packs.rawValue)"
    }

}

extension Wannabe: WannabePackDataSource {

    // MARK: - Wannabe Pack Data Source Functions

    internal func wannabePackPath() -> String {
        return "\(DatabaseKey.setups.rawValue)/\(SetupKey.games.rawValue)/\(self.details.party)/\(SetupKey.cards.rawValue)/\(self.pack.id)"
    }

}
