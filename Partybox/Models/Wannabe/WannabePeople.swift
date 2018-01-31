//
//  WannabePeople.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePeople {
    
    // MARK: - Instance Properties
    
    var indexesToNames: [String] = []
    
    var namesToPersons: [String: WannabePerson] = [:]
    
    var count: Int = 0
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON) {
        for (name, values) in JSON {
            self.add(WannabePerson(name: name, JSON: values))
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
    
    func add(_ person: WannabePerson) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
        
        self.count += 1
    }
    
    func person(index: Int) -> WannabePerson {
        let name = self.indexesToNames[index]
        let person = self.namesToPersons[name]
        
        return person!
    }
    
    func person(name: String) -> WannabePerson {
        let person = self.namesToPersons[name]
        
        return person!
    }
    
    func remove(index: Int) -> WannabePerson {
        let person = self.person(index: index)
        
        self.indexesToNames.remove(at: index)
        self.namesToPersons.removeValue(forKey: person.name)
        
        self.count -= 1
        
        return person
    }
    
    func remove(name: String) -> WannabePerson {
        let person = self.namesToPersons[name]
        
        self.count -= 1
        
        return person!
    }
    
}
