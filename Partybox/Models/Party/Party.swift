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
    
    // MARK: - Database Keys
        
    case details
        
    case people
        
}

enum PartyNotification: String {
    
    // MARK: - Notification Types
    
    case hostChanged = "Party/PartyDetails/hostChanged"
    
    case detailsChanged = "Party/PartyDetails/detailsChanged"
    
    case peopleChanged = "Party/PartyPeople/peopleChanged"
    
}

class Party {
    
    // MARK: - Shared Instance
    
    static var current: Party = Party(id: "", name: "", hostName: "")
    
    // MARK: - Instance Properties
    
    var details: PartyDetails
    
    var people: PartyPeople
        
    // MARK: - Database Properties
    
    var json: [String: Any] {
        let json = [
            Party.current.details.id: [
                PartyKey.details.rawValue: Party.current.details.json,
                PartyKey.people.rawValue: Party.current.people.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init(id: String, name: String, hostName: String) {
        self.details = PartyDetails(id: id, name: name, hostName: hostName)
        self.people = PartyPeople()
    }
    
    init(JSON: JSON) {
        self.details = PartyDetails(JSON: JSON[PartyKey.details.rawValue])
        self.people = PartyPeople(JSON: JSON[PartyKey.people.rawValue])
    }
    
    // MARK: - Database Functions
    
    func setNameForParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        let value = [PartyDetailsKey.name.rawValue: name]
        
        Reference.current.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, _) in
            
            if let _ = error {
                callback("setNameForParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    func setHostForParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        let value = [PartyDetailsKey.hostName.rawValue: name]
        
        Reference.current.database.child(path).updateChildValues(value, withCompletionBlock: {
            (error, _) in
            
            if let _ = error {
                callback("setHostForParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    func removePersonFromParty(name: String, callback: @escaping (String?) -> Void) {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)/\(name)"
        
        Reference.current.database.child(path).removeValue(completionBlock: {
            (error, reference) in
            
            if let _ = error {
                callback("removePersonFromParty error")
            } else {
                callback(nil)
            }
        })
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        self.startObservingHostChanges()
        self.startObservingDetailsChanges()
        self.startObservingPeopleChanges()
    }
    
    func stopObservingChanges() {
        self.stopObservingHostChanges()
        self.stopObservingDetailsChanges()
        self.stopObservingPeopleChanges()
    }
    
    func startObservingHostChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostName.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let hostName = snapshot.value as? String else { return }
            
            Party.current.details.hostName = hostName
            
            let name = Notification.Name(PartyNotification.hostChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingHostChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)/\(PartyDetailsKey.hostName.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingDetailsChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.details = PartyDetails(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.detailsChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingDetailsChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
    func startObservingPeopleChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.current.database.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else { return }
            
            Party.current.people = PartyPeople(JSON: JSON(snapshotJSON))
            
            let name = Notification.Name(PartyNotification.peopleChanged.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        })
    }
    
    func stopObservingPeopleChanges() {
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        
        Reference.current.database.child(path).removeAllObservers()
    }
    
}
