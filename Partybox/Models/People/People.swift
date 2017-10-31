//
//  People.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import FirebaseDatabase
import Foundation

class People {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: People.self)
    
    static let database: DatabaseReference = Database.database().reference().child(People.name)
    
    // MARK: - Instance Properties
    
    var me: Person
    
    private var indexesToNames: [String] = []
    
    private var namesToPersons: [String: Person] = [:]
    
    var count: Int {
        return self.indexesToNames.count
    }
    
    // MARK: - Initialization Methods
    
    init(me: Person) {
        self.me = me
        self.add(me)
    }
    
    // MARK: - People Methods
    
    func add(_ person: Person) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
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
        
        return person
    }
    
    func remove(name: String) -> Person? {
        guard let person = self.namesToPersons[name] else {
            return nil
        }
        
        return person
    }
    
}
