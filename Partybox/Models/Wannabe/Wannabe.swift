//
//  Wannabe.swift
//  Partybox
//
//  Created by Christian Villa on 11/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabeKey: String {
    
    // MARK: - Database Keys
    
    case details
    
    case people
    
    case pack
    
}

class Wannabe {
    
    // MARK: - Shared Instance
    
    static var current: Wannabe = Wannabe()
    
    // MARK: - Instance Properties
        
    var details: WannabeDetails
    
    var people: WannabePeople
    
    var pack: WannabePack
    
    // MARK: - JSON Properties
    
    var json: [String: Any] { 
        let json = [
            Party.current.details.id: [
                WannabeKey.details.rawValue: Wannabe.current.details.json,
                WannabeKey.people.rawValue: Wannabe.current.people.json,
                WannabeKey.pack.rawValue: Wannabe.current.pack.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.details = WannabeDetails()
        self.people = WannabePeople()
        self.pack = WannabePack()
    }
    
    init(JSON: JSON) {
        self.details = WannabeDetails(JSON: JSON[WannabeKey.details.rawValue])
        self.people = WannabePeople(JSON: JSON[WannabeKey.people.rawValue])
        self.pack = WannabePack(JSON: JSON[WannabeKey.pack.rawValue])
    }
    
    // MARK: - Database Functions
    
    func loadPackCollection(callback: @escaping (String?) -> Void) {
        if WannabePack.collection.count > 0 {
            callback(nil)
        }
        
        let path = "\(ReferenceKey.setups.rawValue)/games/\(Wannabe.current.details.id)/packs"
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            for (_, packJSON) in JSON(snapshotJSON) {
                WannabePack.collection.append(WannabePack(JSON: packJSON))
            }
            
            callback(nil)
        })
    }
    
    func loadPack(id: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.packs.rawValue)/\(Wannabe.current.details.id)/\(id)"
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.pack = WannabePack(JSON: JSON(snapshotJSON))
            
            callback(nil)
        })
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        self.startObservingDetailsChanges()
        self.startObservingPeopleChanges()
        self.startObservingPackChanges()
    }
    
    func stopObservingChanges() {
        self.stopObservingDetailsChanges()
        self.stopObservingPeopleChanges()
        self.stopObservingPackChanges()
    }
    
    func startObservingDetailsChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.details = WannabeDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingDetailsChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingPeopleChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.people = WannabePeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPeopleChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingPackChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.pack.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.pack = WannabePack(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.packChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPackChanges() {
        let path = "\(ReferenceKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.pack.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
}
