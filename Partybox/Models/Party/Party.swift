//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum PartyKey: String {
    
    case details
        
    case people
    
}

class Party {
    
    // MARK: - Instance Properties
    
    var details: PartyDetails
    
    var people: PartyPeople
    
    // MARK: - Initialization Methods
    
    init(details: PartyDetails, people: PartyPeople) {
        self.details = details
        self.people = people
    }
    
    init(JSON: JSON) {
        self.details = PartyDetails(JSON: JSON[PartyKey.details.rawValue])
        self.people = PartyPeople(JSON: JSON[PartyKey.people.rawValue])
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            PartyKey.details.rawValue: self.details.toJSON(),
            PartyKey.people.rawValue: self.people.toJSON()
        ] as [String: Any]
        
        return JSON
    }
    
}
