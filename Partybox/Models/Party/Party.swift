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

    var details: PartyDetails = PartyDetails()

    var people: PartyPeople = PartyPeople()

    // MARK: - Construction Functions

    static func construct(name: String) -> Party {
        let party = Party()
        party.details = PartyDetails.construct(name: name, dataSource: party)
        party.people = PartyPeople.construct(dataSource: party)
        return party
    }

    static func construct(id: String) -> Party {
        let party = Party()
        party.details = PartyDetails.construct(id: id, dataSource: party)
        party.people = PartyPeople.construct(dataSource: party)
        return party
    }

    // MARK: - Party Functions

    func start(user: User, callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            let person = PartyPerson.construct(name: user.name)

            self.details.host = person.name

            let values = [
                PartyKey.details.rawValue: [
                    PartyDetailsKey.id.rawValue: self.details.id,
                    PartyDetailsKey.name.rawValue: self.details.name,
                    PartyDetailsKey.game.rawValue: self.details.game,
                    PartyDetailsKey.status.rawValue: self.details.status,
                    PartyDetailsKey.host.rawValue: self.details.host,
                    PartyDetailsKey.time.rawValue: ServerValue.timestamp(),
                ],
                PartyKey.people.rawValue: [
                    person.name: [
                        PartyPersonKey.name.rawValue: person.name,
                        PartyPersonKey.points.rawValue: person.points,
                        PartyPersonKey.emoji.rawValue: person.emoji
                    ]
                ]
            ]

            path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your party\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

                Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
                    (snapshot) in

                    if !snapshot.exists() {
                        callback("We ran into a problem while starting your party\n\nPlease try again")
                        return
                    }

                    guard let data = snapshot.value as? [String: Any] else {
                        callback("We ran into a problem while starting your party\n\nPlease try again")
                        return
                    }

                    let json = JSON(data)

                    self.details = PartyDetails.construct(json: json[PartyKey.details.rawValue], dataSource: self)
                    self.details.startObservingChanges()

                    self.people = PartyPeople.construct(json: json[PartyKey.people.rawValue], dataSource: self)
                    self.people.startObservingChanges()

                    callback(nil)
                })
            })
        })
    }

    func end(user: User, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    func join(user: User, callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            path = "\(PartyKey.people.rawValue)/\(user.name)"

            if snapshot.hasChild(path) {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }

            let person = PartyPerson.construct(name: user.name)

            let values = [
                person.name: [
                    PartyPersonKey.name.rawValue: person.name,
                    PartyPersonKey.points.rawValue: person.points,
                    PartyPersonKey.emoji.rawValue: person.emoji
                ]
            ]

            path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)"

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your party\n\nPlease try again")
                    return
                }

                path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

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

                    self.details = PartyDetails.construct(json: json[PartyKey.details.rawValue], dataSource: self)
                    self.details.startObservingChanges()

                    self.people = PartyPeople.construct(json: json[PartyKey.people.rawValue], dataSource: self)
                    self.people.startObservingChanges()

                    callback(nil)
                })
            })
        })
    }

    func leave(user: User, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)/\(user.name)"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue(completionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }
    
}

extension Party: PartyDetailsDataSource {

    // MARK: - Party Details Data Source Functions

    internal func partyDetailsPath() -> String {
        return "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"
    }

}

extension Party: PartyPeopleDataSource {

    // MARK: - Party People Data Source Functions

    internal func partyPeoplePath() -> String {
        return "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)"
    }

}
