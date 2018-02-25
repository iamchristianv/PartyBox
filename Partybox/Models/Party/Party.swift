//
//  Party.swift
//  Partybox
//
//  Created by Christian Villa on 10/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyKey: String {
    
    // MARK: - Database Keys
        
    case details
        
    case people
        
}

class Party {
    
    // MARK: - Shared Instance
    
    static var current: Party = Party()
    
    // MARK: - Instance Properties
    
    var details: PartyDetails
    
    var people: PartyPeople
        
    // MARK: - Database Properties
    
    var json: [String: Any] {
        let json = [
            Party.current.details.id: [
                PartyKey.details.rawValue: Party.current.details.json,
                PartyKey.people.rawValue: Party.current.people.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.details = PartyDetails()
        self.people = PartyPeople()
    }
    
}
