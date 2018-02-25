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
    
    var people: [PartyPerson]
    
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
            self.add(PartyPerson(name: name, JSON: personJSON))
        }
    }
    
    // MARK: - People Functions
    
    func add(_ person: PartyPerson) {
        self.people.append(person)
    }
    
    func person(index: Int) -> PartyPerson? {
        if index < 0 || index >= self.people.count {
            return nil
        }
        
        return self.people[index]
    }
    
    func person(name: String) -> PartyPerson? {
        for person in self.people {
            if person.name == name {
                return person
            }
        }
        
        return nil
    }
    
    func remove(index: Int) -> PartyPerson? {
        if index < 0 || index >= self.people.count {
            return nil
        }
        
        return self.people.remove(at: index)
    }
    
    func remove(name: String) -> PartyPerson? {
        for i in 0 ..< self.people.count {
            let person = self.people[i]
            
            if person.name == name {
                return person
            }
        }
        
        return nil
    }
    
    // MARK: - Utility Functions
    
    static func randomEmoji() -> String {
        let emojis = ["😊"]
        
        let randomIndex = Int(arc4random())
        let randomEmoji = emojis[randomIndex % emojis.count]
        
        return randomEmoji
    }
    
}
