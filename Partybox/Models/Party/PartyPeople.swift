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
    
    private var people: [PartyPerson]
    
    var count: Int {
        return self.people.count
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.people = []
    }
    
    init(JSON: JSON) {
        self.people = []
        
        for (_, personJSON) in JSON {
            self.add(PartyPerson(JSON: personJSON))
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
    
    func person(id: String) -> PartyPerson? {
        for person in self.people {
            if person.id == id {
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
    
    func remove(id: String) -> PartyPerson? {
        for index in 0 ..< self.people.count {
            let person = self.people[index]
            
            if person.id == id {
                return self.people.remove(at: index)
            }
        }
        
        return nil
    }
    
    // MARK: - Utility Functions
    
    private func randomEmoji() -> String {
        let emojis = ["😊"]
        
        let randomIndex = Int(arc4random())
        let randomEmoji = emojis[randomIndex % emojis.count]
        
        return randomEmoji
    }
    
}
