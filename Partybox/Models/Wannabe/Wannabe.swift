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
    
    // MARK: - Instance Properties
        
    var details: WannabeDetails = WannabeDetails(JSON: JSON(""))
    
    var people: WannabePeople = WannabePeople(JSON: JSON(""))
    
    var pack: WannabePack = WannabePack(JSON: JSON(""))
    
    // MARK: - JSON Properties
    
    var json: [String: Any] { 
        let json = [
            self.details.id: [
                WannabeKey.details.rawValue: self.details.json,
                WannabeKey.people.rawValue: self.people.json,
                WannabeKey.pack.rawValue: self.pack.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        Reference.current.database.child(self.details.path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            let detailsJSON = JSON(snapshotJSON)
            
            self.details = WannabeDetails(JSON: detailsJSON)
            
            let name = Notification.Name(GameNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
        
        Reference.current.database.child(self.people.path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            let peopleJSON = JSON(snapshotJSON)
            
            self.people = WannabePeople(JSON: peopleJSON)
            
            let name = Notification.Name(GameNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingChanges() {
        Reference.current.database.child(self.details.path).removeAllObservers()
        Reference.current.database.child(self.people.path).removeAllObservers()
    }
    
}
