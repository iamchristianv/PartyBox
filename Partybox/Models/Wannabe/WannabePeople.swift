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

    private var people: [WannabePerson]
    
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
            self.add(WannabePerson(JSON: personJSON))
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
    
    func person(id: String) -> WannabePerson? {
        for person in self.people {
            if person.id == id {
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
    
    func remove(id: String) -> WannabePerson? {
        for index in 0 ..< self.people.count {
            let person = self.people[index]
            
            if person.id == id {
                return self.people.remove(at: index)
            }
        }
        
        return nil
    }

    // MARK: - Utility Functions

    func randomPerson() -> WannabePerson? {
        if self.people.isEmpty {
            return nil
        }

        let randomIndex = Int(arc4random()) % self.people.count
        let randomPerson = self.people[randomIndex]

        return randomPerson
    }
    
}
