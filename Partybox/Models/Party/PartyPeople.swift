//
//  PartyPeople.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyPeopleNotification: String {
    
    case changed
    
}

class PartyPeople {
    
    // MARK: - Instance Properties
    
    var indexesToNames: [String] = []
    
    var namesToPersons: [String: PartyPerson] = [:]
    
    var count: Int = 0
    
    var shouldPostNotifications: Bool = false
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String: Any] {
        var JSON = [:] as [String: Any]
        
        for person in self.namesToPersons.values {
            for (name, values) in person.toJSON() {
                JSON[name] = values
            }
        }
        
        return JSON
    }
    
    // MARK: - Database Functions
    
    func startSynchronizing() {
        let path = "\(Session.id)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)"
        
        Reference.child(path).observe(.value, with: {
            (snapshot) in
            
            guard let values = snapshot.value as? [String: Any] else { return }
            
            let people = JSON(values)
            
            for (name, values) in people {
                self.add(PartyPerson(name: name, JSON: values))
            }
            
            if self.shouldPostNotifications {
                NotificationCenter.default.post(name: Notification.Name(PartyPeopleNotification.changed.rawValue), object: nil)
            }
        })
    }
    
    func stopSynchronizing() {
        let path = "\(Session.id)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)"

        Reference.child(path).removeAllObservers()
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        self.shouldPostNotifications = true
    }
    
    func stopObservingChanges() {
        self.shouldPostNotifications = false
    }
    
    // MARK: - People Functions
    
    func add(_ person: PartyPerson) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
        
        self.count += 1
    }
    
    func person(index: Int) -> PartyPerson? {
        let name = self.indexesToNames[index]
        let person = self.namesToPersons[name]
        
        return person
    }
    
    func person(name: String) -> PartyPerson? {
        let person = self.namesToPersons[name]
        
        return person
    }
    
    func remove(index: Int) -> PartyPerson? {
        guard let person = self.person(index: index) else {
            return nil
        }
        
        self.indexesToNames.remove(at: index)
        self.namesToPersons.removeValue(forKey: person.name)
        
        self.count -= 1
        
        return person
    }
    
    func remove(name: String) -> PartyPerson? {
        guard let person = self.namesToPersons[name] else {
            return nil
        }
        
        self.count -= 1
        
        return person
    }
    
}
