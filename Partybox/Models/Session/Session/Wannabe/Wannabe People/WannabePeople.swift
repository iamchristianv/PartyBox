//
//  WannabePeople.swift
//  Partybox
//
//  Created by Christian Villa on 5/5/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class WannabePeople {

    // MARK: - Instance Properties

    var persons: OrderedSet<WannabePerson> = OrderedSet<WannabePerson>()

    private var dataSource: WannabePeopleDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabePeopleDataSource) -> WannabePeople {
        let people = WannabePeople()
        people.persons = OrderedSet<WannabePerson>()
        people.dataSource = dataSource
        return people
    }

    static func construct(json: JSON, dataSource: WannabePeopleDataSource) -> WannabePeople {
        let people = WannabePeople()
        people.persons = OrderedSet<WannabePerson>()
        people.dataSource = dataSource

        for (_, value) in json {
            let person = WannabePerson.construct(json: value)
            people.persons.add(person)
        }

        return people
    }

    // MARK: - Database Functions

    func update(values: [String: Any], callback: @escaping (String?) -> Void) {
        let path = self.dataSource.wannabePeopleWannabePeoplePath()

        Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    func startObservingChanges() {
        let path = self.dataSource.wannabePeopleWannabePeoplePath()

        Database.database().reference().child(path).observe(.childAdded, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson.construct(json: json)
            self.persons.add(person)

            let name = Notification.Name(WannabePeopleNotification.personAdded.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson.construct(json: json)
            self.persons.add(person)

            let name = Notification.Name(WannabePeopleNotification.personChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })

        Database.database().reference().child(path).observe(.childRemoved, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                return
            }

            let json = JSON(data)

            let person = WannabePerson.construct(json: json)
            self.persons.remove(person)

            let name = Notification.Name(WannabePeopleNotification.personRemoved.rawValue)
            NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
        })
    }

    func stopObservingChanges() {
        let path = self.dataSource.wannabePeopleWannabePeoplePath()

        Database.database().reference().child(path).removeAllObservers()
    }

}
