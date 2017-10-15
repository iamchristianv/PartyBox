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
    
    // MARK: - Database Reference
    
    static let database: DatabaseReference = Database.database().reference().child(String(describing: People.self))
    
    // MARK: - Properties
    
    private var indexesToNames: [String] = []
    
    private var namesToPersons: [String: Person] = [:]
    
    // MARK: - People
    
    func add(_ person: Person) {
        let name = person.name
        
        self.indexesToNames.append(name)
        self.namesToPersons[name] = person
    }
    
    func person(at index: Int) -> Person? {
        if index >= self.indexesToNames.count {
            return nil
        }
        
        let name = self.indexesToNames[index]
        let person = self.namesToPersons[name]
        
        return person
    }
    
    func remove(at index: Int) {
        if index >= self.indexesToNames.count {
            return
        }
        
        let name = self.indexesToNames[index]
        self.indexesToNames.remove(at: index)
        self.namesToPersons.removeValue(forKey: name)
    }
    
}
