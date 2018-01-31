//
//  PartyDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyDetailsKey: String {
    
    case name
    
    case hostName
    
}

enum PartyDetailsNotification: String {
    
    case changed
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var name: String = ""
    
    var hostName: String = ""
    
    var shouldPostNotifications: Bool = false
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String : Any] {
        let JSON = [
            PartyDetailsKey.name.rawValue: self.name,
            PartyDetailsKey.hostName.rawValue: self.hostName
        ] 
        
        return JSON
    }
    
    // MARK: - Database Functions
    
    func startSynchronizing() {
        let path = "\(Session.id)/\(SessionKey.party.rawValue)/\(PartyKey.details.rawValue)"
        
        Reference.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let values = snapshot.value as? [String: Any] else { return }
            
            let details = JSON(values)
            
            self.name = details[PartyDetailsKey.name.rawValue].stringValue
            self.hostName = details[PartyDetailsKey.hostName.rawValue].stringValue
            
            Session.userIsHost = (Session.userName == self.hostName)
            
            if self.shouldPostNotifications {
                NotificationCenter.default.post(name: Notification.Name(PartyDetailsNotification.changed.rawValue), object: nil)
            }
        })
    }
    
    func stopSynchronizing() {
        let path = "\(Session.id)/\(SessionKey.party.rawValue)/\(PartyKey.details.rawValue)"

        Reference.child(path).removeAllObservers()
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        self.shouldPostNotifications = true
    }
    
    func stopObservingChanges() {
        self.shouldPostNotifications = false
    }
    
}
