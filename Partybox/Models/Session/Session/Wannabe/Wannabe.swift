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

    var manual: WannabeManual = WannabeManual()

    var details: WannabeDetails = WannabeDetails()
    
    var people: WannabePeople = WannabePeople()

    var pack: WannabePack = WannabePack()

    private var dataSource: WannabeDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabeDataSource) -> Wannabe {
        let wannabe = Wannabe()
        wannabe.manual = WannabeManual.construct()
        wannabe.details = WannabeDetails.construct(dataSource: wannabe)
        wannabe.people = WannabePeople.construct(dataSource: wannabe)
        wannabe.pack = WannabePack.construct()
        wannabe.dataSource = dataSource
        return wannabe
    }
    
    // MARK: - Wannabe Functions

    func start(callback: @escaping (String?) -> Void) {
        var path = self.dataSource.wannabeWannabePath()

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            let person = WannabePerson.construct(name: self.dataSource.wannabeUserName())

            let values = [
                WannabeKey.details.rawValue: [
                    WannabeDetailsKey.id.rawValue: self.details.id,
                    WannabeDetailsKey.name.rawValue: self.details.name,
                    WannabeDetailsKey.status.rawValue: self.details.status,
                    WannabeDetailsKey.rounds.rawValue: self.details.rounds,
                    WannabeDetailsKey.activeCard.rawValue: [
                        WannabeCardKey.hint.rawValue: self.details.activeCard.hint,
                        WannabeCardKey.action.rawValue: self.details.activeCard.action
                    ],
                    WannabeDetailsKey.wannabeName.rawValue: self.details.wannabeName
                ],
                WannabeKey.people.rawValue: [
                    person.name: [
                        WannabePersonKey.name.rawValue: person.name,
                        WannabePersonKey.points.rawValue: person.points,
                        WannabePersonKey.voteName.rawValue: person.voteName
                    ]
                ]
            ]

            path = self.dataSource.wannabeWannabePath()

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while starting your game\n\nPlease try again")
                    return
                }

                path = self.dataSource.wannabeWannabePath()

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

    func end() {
        let path = self.dataSource.wannabeWannabePath()

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue()
    }

    func join(callback: @escaping (String?) -> Void) {
        var path = self.dataSource.wannabeWannabePath()

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We couldn't find a game with your invite code\n\nPlease try again")
                return
            }

            let person = WannabePerson.construct(name: self.dataSource.wannabeUserName())

            let values = [
                person.name: [
                    WannabePersonKey.name.rawValue: person.name,
                    WannabePersonKey.points.rawValue: person.points,
                    WannabePersonKey.voteName.rawValue: person.voteName
                ]
            ]

            path = self.dataSource.wannabeWannabePeoplePath()

            Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game\n\nPlease try again")
                    return
                }

                path = self.dataSource.wannabeWannabePath()

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

    func leave(callback: @escaping (String?) -> Void) {
        let path = self.dataSource.wannabeUserPath()

        self.details.stopObservingChanges()
        self.people.stopObservingChanges()

        Database.database().reference().child(path).removeValue()
    }
    
}

extension Wannabe: WannabeDetailsDataSource {

    internal func wannabeDetailsWannabeDetailsPath() -> String {
        return self.dataSource.wannabeWannabeDetailsPath()
    }

    internal func wannabeDetailsRounds() -> Int {
        return self.manual.rounds.first!
    }

}

extension Wannabe: WannabePeopleDataSource {

    internal func wannabePeopleWannabePeoplePath() -> String {
        return self.dataSource.wannabeWannabePeoplePath()
    }

}
