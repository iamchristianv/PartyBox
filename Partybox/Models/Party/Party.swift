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

enum PartyNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Party/PartyDetails/detailsChanged"
    
    case peopleChanged = "Party/PartyPeople/peopleChanged"
    
}

class Party {
    
    // MARK: - Shared Instance
    
    static var current: Party = Party()
    
    // MARK: - Instance Properties
    
    var details: PartyDetails = PartyDetails(JSON: JSON(""))
    
    var people: PartyPeople = PartyPeople(JSON: JSON(""))
        
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
    
}
