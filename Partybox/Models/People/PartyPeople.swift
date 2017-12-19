//
//  PartyPeople.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class PartyPeople {
    
    // MARK: - Instance Properties
    
    var indexesToNames: [String]
    
    var namesToPersons: [String: PartyPerson]
    
    var count: Int
    
    // MARK: - Initialization Methods
    
    init() {
        self.indexesToNames = []
        self.namesToPersons = [:]
        self.count = 0
    }
    
    init(JSON: JSON) {
        self.indexesToNames = []
        self.namesToPersons = [:]
        self.count = 0
        
        for (name, values) in JSON {
            self.add(PartyPerson(name: name, JSON: values))
        }
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        var JSON = [:] as [String: Any]
        
        for person in self.namesToPersons.values {
            for (name, values) in person.toJSON() {
                JSON[name] = values
            }
        }
        
        return JSON
    }
    
    // MARK: - People Methods
    
    func add(_ person: PartyPerson) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
        
        self.count += 1
    }
    
    func person(index: Int) -> PartyPerson? {
        if index >= self.indexesToNames.count {
            return nil
        }
        
        let name = self.indexesToNames[index]
        let person = self.namesToPersons[name]
        
        return person
    }
    
    func person(name: String) -> PartyPerson? {
        guard let person = self.namesToPersons[name] else {
            return nil
        }
        
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
