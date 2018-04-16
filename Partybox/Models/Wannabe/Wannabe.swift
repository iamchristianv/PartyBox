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

enum WannabeKey: String {
    
    // MARK: - Property Keys
    
    case details
    
    case people
    
    case pack
    
}

class Wannabe {
    
    // MARK: - Instance Properties
        
    var details: WannabeDetails
    
    var people: WannabePeople
    
    var pack: WannabePack
    
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
        
        let path = "\(DatabaseKey.setups.rawValue)/games/\(Wannabe.current.details.id)/packs"
        
        Database.current.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            for (_, packJSON) in JSON(snapshotJSON) {
                WannabePack.collection.append(WannabePack(JSON: packJSON))
            }
            
            callback(nil)
        })
    }
    
    func loadPack(id: String, callback: @escaping (String?) -> Void) {
        let path = "\(DatabaseKey.packs.rawValue)/\(Wannabe.current.details.id)/\(id)"
        
        Database.current.child(path).observeSingleEvent(of: .value, with: {
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
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Database.current.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.details = WannabeDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingDetailsChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.details.rawValue)"
        
        Database.current.child(path).removeAllObservers()
    }
    
    func startObservingPeopleChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Database.current.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.people = WannabePeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPeopleChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        
        Database.current.child(path).removeAllObservers()
    }
    
    func startObservingPackChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.pack.rawValue)"
        
        Database.current.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Wannabe.current.pack = WannabePack(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(GameNotification.packChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPackChanges() {
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.pack.rawValue)"
        
        Database.current.child(path).removeAllObservers()
    }
    
}
