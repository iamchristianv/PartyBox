//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyKey: String {
    
    case details
        
    case people
        
}

enum PartyNotification: String {
    
    case detailsChanged
    
    case peopleChanged
    
}

class Party {
    
    // MARK: - Class Properties
    
    var details: PartyDetails = PartyDetails()
    
    var people: PartyPeople = PartyPeople()
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String: Any] {
        let JSON = [
            PartyKey.details.rawValue: self.details.toJSON(),
            PartyKey.people.rawValue: self.people.toJSON()
        ]
        
        return JSON
    }
    
    // MARK: - Database Functions
    
    func startSynchronizing() {
        self.details.startSynchronizing()
        self.people.startSynchronizing()
    }
    
    func stopSynchronizing() {
        self.details.stopSynchronizing()
        self.people.stopSynchronizing()
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        var name = Notification.Name(PartyDetailsNotification.changed.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(detailsChanged), name: name, object: nil)
        
        self.details.startObservingChanges()
        
        name = Notification.Name(PartyPeopleNotification.changed.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(peopleChanged), name: name, object: nil)
        
        self.people.startObservingChanges()
    }
    
    func stopObservingChanges() {
        var name = Notification.Name(PartyDetailsNotification.changed.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        self.details.stopObservingChanges()
        
        name = Notification.Name(PartyPeopleNotification.changed.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        self.people.stopObservingChanges()
    }
    
    @objc func detailsChanged() {
        NotificationCenter.default.post(name: Notification.Name(PartyNotification.detailsChanged.rawValue), object: nil)
    }
    
    @objc func peopleChanged() {
        NotificationCenter.default.post(name: Notification.Name(PartyNotification.peopleChanged.rawValue), object: nil)
    }
    
}
