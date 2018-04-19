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
        
    var details: WannabeDetails
    
    var people: WannabePeople
    
    var pack: WannabePack

    private var database: DatabaseReference
    
    // MARK: - Initialization Functions
    
    init() {
        self.details = WannabeDetails()
        self.people = WannabePeople()
        self.pack = WannabePack()
        self.database = Database.database().reference()
    }
    
    init(JSON: JSON) {
        self.details = WannabeDetails(JSON: JSON[GameKey.details.rawValue])
        self.people = WannabePeople(JSON: JSON[GameKey.people.rawValue])
        self.pack = WannabePack(JSON: JSON[GameKey.pack.rawValue])
        self.database = Database.database().reference()
    }
    
    // MARK: - Database Functions

    func start(callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)"

        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if snapshot.exists() {
                callback("We ran into a problem while starting your game\n\nPlease try again")
                return
            }

            let person = WannabePerson()
            path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
            person.id = self.database.child(path).childByAutoId().key
            person.name = User.current.name

            path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)"
            let values = [
                GameKey.details.rawValue: [
                    WannabeDetailsKey.id.rawValue: self.details.id,
                    WannabeDetailsKey.name.rawValue: self.details.name,
                    WannabeDetailsKey.status.rawValue: self.details.status,
                    WannabeDetailsKey.value.rawValue: self.details.value,
                    WannabeDetailsKey.wannabeId.rawValue: self.details.wannabeId,
                    WannabeDetailsKey.timestamp.rawValue: ServerValue.timestamp()
                ],
                GameKey.people.rawValue: [
                    person.id: [
                        PartyPersonKey.id.rawValue: person.id,
                        PartyPersonKey.name.rawValue: person.name,
                        PartyPersonKey.status.rawValue: person.status,
                        PartyPersonKey.value.rawValue: person.value,
                        PartyPersonKey.points.rawValue: person.points
                    ]
                ]
            ]

            self.database.child(path).updateChildValues(values, withCompletionBlock: {
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

    func join(callback: @escaping (String?) -> Void) {
        var path = "\(DatabaseKey.parties.rawValue)/\(Party.current.details.id)"

        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            if !snapshot.exists() {
                callback("We ran into a problem while joining your game")
                return
            }

            let person = WannabePerson()
            path = "\(DatabaseKey.parties.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
            person.id = self.database.child(path).childByAutoId().key
            person.name = User.current.name

            path = "\(DatabaseKey.parties.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
            let values = [
                person.id: [
                    PartyPersonKey.id.rawValue: person.id,
                    PartyPersonKey.name.rawValue: person.name,
                    PartyPersonKey.status.rawValue: person.status,
                    PartyPersonKey.value.rawValue: person.value,
                    PartyPersonKey.points.rawValue: person.points
                ]
            ]

            self.database.child(path).updateChildValues(values, withCompletionBlock: {
                (error, reference) in

                if error != nil {
                    callback("We ran into a problem while joining your game")
                    return
                }

                self.startObservingChanges()
                callback(nil)
            })
        })
    }

    func end(callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.parties.rawValue)/\(Party.current.details.id)"

        self.database.child(path).removeValue(completionBlock: {
            (error, reference) in

            if error != nil {
                callback("We ran into a problem while ending your game")
                return
            }

            self.stopObservingChanges()
            callback(nil)
        })
    }
    
    func loadPacks(callback: @escaping (String?) -> Void) {
        if !WannabePack.collection.isEmpty {
            callback(nil)
        }

        let path = "\(DatabaseKey.packs.rawValue)/\(self.details.id)"
        
        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let collectionJSON = JSON(snapshotJSON)
            
            for (_, packJSON) in collectionJSON {
                WannabePack.collection.append(WannabePack(JSON: packJSON))
            }
            
            callback(nil)
        })
    }
    
    func loadPack(id: String, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.packs.rawValue)/\(self.details.id)/\(id)"
        
        self.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let packJSON = JSON(snapshotJSON)
            
            self.pack = WannabePack(JSON: packJSON)
            
            callback(nil)
        })
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        self.startObservingDetailsChanges()
        self.startObservingPeopleChanges()
    }
    
    func stopObservingChanges() {
        self.stopObservingDetailsChanges()
        self.stopObservingPeopleChanges()
    }
    
    func startObservingDetailsChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        self.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }

            let detailsJSON = JSON(snapshotJSON)
            
            self.details = WannabeDetails(JSON: detailsJSON)
            
            let name = Notification.Name(GameNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingDetailsChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        self.database.child(path).removeAllObservers()
    }
    
    func startObservingPeopleChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        self.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else {
                return
            }

            let peopleJSON = JSON(snapshotJSON)
            
            self.people = WannabePeople(JSON: peopleJSON)
            
            let name = Notification.Name(GameNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPeopleChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        self.database.child(path).removeAllObservers()
    }
    
}
