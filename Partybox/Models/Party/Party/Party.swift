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

    private var dataSource: PartyDataSource!

    // MARK: - Construction Functions

    static func construct(name: String, dataSource: PartyDataSource) -> Party {
        let party = Party()
        party.details = PartyDetails.construct(name: name, dataSource: party)
        party.people = PartyPeople.construct(dataSource: party)
        party.dataSource = dataSource
        return party
    }

    static func construct(id: String, dataSource: PartyDataSource) -> Party {
        let party = Party()
        party.details = PartyDetails.construct(id: id, dataSource: party)
        party.people = PartyPeople.construct(dataSource: party)
        party.dataSource = dataSource
        return party
    }

    // MARK: - Party Functions

    func start(callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your party\n\nPlease try again")
                return
            }

            let person = PartyPerson.construct(name: self.dataSource.partyUserName())
            self.details.hostName = person.name

            let values = [
                PartyKey.details.rawValue: [
                    PartyDetailsKey.id.rawValue: self.details.id,
                    PartyDetailsKey.name.rawValue: self.details.name,
                    PartyDetailsKey.status.rawValue: self.details.status,
                    PartyDetailsKey.gameId.rawValue: self.details.gameId,
                    PartyDetailsKey.hostName.rawValue: self.details.hostName,
                    PartyDetailsKey.startTime.rawValue: ServerValue.timestamp(),
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

    func end() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue()
    }

    func join(callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a party with your invite code\n\nPlease try again")
                return
            }

            path = "\(PartyKey.people.rawValue)/\(self.dataSource.partyUserName())"

            if snapshot.hasChild(path) {
                callback("Someone at the party already has your name\n\nPlease try again")
                return
            }

            let person = PartyPerson.construct(name: self.dataSource.partyUserName())

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

    func leave() {
        let path = "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)/\(self.dataSource.partyUserName())"

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue()
    }
    
}

extension Party: PartyDetailsDataSource {

    internal func partyDetailsPath() -> String {
        return "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.details.rawValue)"
    }

}

extension Party: PartyPeopleDataSource {

    internal func partyPeoplePath() -> String {
        return "\(DatabaseKey.parties.rawValue)/\(self.details.id)/\(PartyKey.people.rawValue)"
    }

}
