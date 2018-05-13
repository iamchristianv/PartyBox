//
//  PartyPeople.swift
//  Partybox
//
//  Created by Christian Villa on 5/3/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class PartyPeople {

    // MARK: - Instance Properties

    var persons: OrderedSet<PartyPerson> = OrderedSet<PartyPerson>()

    private var dataSource: PartyPeopleDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: PartyPeopleDataSource) -> PartyPeople {
        let people = PartyPeople()
        people.persons = OrderedSet<PartyPerson>()
        people.dataSource = dataSource
        return people
    }

    static func construct(json: JSON, dataSource: PartyPeopleDataSource) -> PartyPeople {
        let people = PartyPeople()
        people.persons = OrderedSet<PartyPerson>()
        people.dataSource = dataSource

        for (_, value) in json {
            let person = PartyPerson.construct(json: value)
            people.persons.add(person)
        }

        return people
    }

    // MARK: - Database Functions

    func update(values: [String: Any], callback: @escaping (String?) -> Void) {
        let path = self.dataSource.partyPeoplePath()

        Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    func startObservingChanges() {
        let path = self.dataSource.partyPeoplePath()

        Database.database().reference().child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson.construct(json: json)
            self.persons.add(person)

            let name = Notification.Name(PartyPeopleNotification.personAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson.construct(json: json)
            self.persons.add(person)

            let name = Notification.Name(PartyPeopleNotification.personChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        Database.database().reference().child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = PartyPerson.construct(json: json)
            self.persons.remove(person)

            let name = Notification.Name(PartyPeopleNotification.personRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    func stopObservingChanges() {
        let path = self.dataSource.partyPeoplePath()

        Database.database().reference().child(path).removeAllObservers()
    }

}
