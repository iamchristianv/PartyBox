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

    var people: [WannabePerson]
    
    var count: Int {
        return self.people.count
    }
    
    // MARK: - Database Properties
    
    var json: [String: Any] {
        var json = [:] as [String: Any]
        
        for person in self.people {
            for (name, values) in person.json {
                json[name] = values
            }
        }
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.people = []
    }
    
    init(JSON: JSON) {
        self.people = []
        
        for (name, personJSON) in JSON {
            self.add(WannabePerson(name: name, JSON: personJSON))
        }
    }
    
    // MARK: - People Functions
    
    func add(_ person: WannabePerson) {
        self.people.append(person)
    }
    
    func person(index: Int) -> WannabePerson? {
        if index < 0 || index >= self.people.count {
            return nil
        }
        
        return self.people[index]
    }
    
    func person(name: String) -> WannabePerson? {
        for person in self.people {
            if person.name == name {
                return person
            }
        }
        
        return nil
    }
    
    func remove(index: Int) -> WannabePerson? {
        if index < 0 || index >= self.people.count {
            return nil
        }
        
        return self.people.remove(at: index)
    }
    
    func remove(name: String) -> WannabePerson? {
        for i in 0 ..< self.people.count {
            let person = self.people[i]
            
            if person.name == name {
                return person
            }
        }
        
        return nil
    }
    
}
