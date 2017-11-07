//
//  People.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class People {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: People.self)
    
    // MARK: - Instance Properties
    
    var count: Int 
    
    private var indexesToNames: [String]
    
    private var namesToPersons: [String: Person]
    
    // MARK: - Initialization Methods
    
    init(persons: [Person]) {
        // for client use
        self.count = 0
        self.indexesToNames = []
        self.namesToPersons = [:]
        
        for person in persons {
            self.add(person)
        }
    }
    
    init(JSON: JSON) {
        // for server use
        self.count = 0
        self.indexesToNames = []
        self.namesToPersons = [:]
        
        for (name, values) in JSON {
            let person = Person(name: name, JSON: values)
            self.add(person)
        }
    }
    
    func toJSON() -> [String: Any] {
        var JSON = [
            People.name: [:]
        ]
        
        for person in self.namesToPersons.values {
            for (name, values) in person.toJSON() {
                JSON[People.name]![name] = values
            }
        }
        
        return JSON
    }
    
    // MARK: - People Methods
    
    func add(_ person: Person) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
        
        self.count += 1
    }
    
    func person(index: Int) -> Person? {
        if index >= self.indexesToNames.count {
            return nil
        }
        
        let name = self.indexesToNames[index]
        let person = self.namesToPersons[name]
        
        return person
    }
    
    func person(name: String) -> Person? {
        guard let person = self.namesToPersons[name] else {
            return nil
        }
        
        return person
    }
    
    func remove(index: Int) -> Person? {
        guard let person = self.person(index: index) else {
            return nil
        }
        
        self.indexesToNames.remove(at: index)
        self.namesToPersons.removeValue(forKey: person.name)
        
        self.count -= 1
        
        return person
    }
    
    func remove(name: String) -> Person? {
        guard let person = self.namesToPersons[name] else {
            return nil
        }
        
        self.count -= 1
        
        return person
    }
    
}
