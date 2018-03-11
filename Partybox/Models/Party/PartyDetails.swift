//
//  PartyDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyDetailsKey: String {
    
    // MARK: - Database Keys
    
    case id
    
    case name
    
    case hostName
    
    case maxCapacity
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var id: String
    
    var name: String
    
    var hostName: String
    
    var maxCapacity: Int
    
    // MARK: - Database Properties
    
    var json: [String: Any] {
        let json = [
            PartyDetailsKey.id.rawValue: self.id,
            PartyDetailsKey.name.rawValue: self.name,
            PartyDetailsKey.hostName.rawValue: self.hostName,
            PartyDetailsKey.maxCapacity.rawValue: self.maxCapacity
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init(id: String, name: String, hostName: String) {
        self.id = id
        self.name = name
        self.hostName = hostName
        self.maxCapacity = 10
    }
    
    init(JSON: JSON) {
        self.id = JSON[PartyDetailsKey.id.rawValue].stringValue
        self.name = JSON[PartyDetailsKey.name.rawValue].stringValue
        self.hostName = JSON[PartyDetailsKey.hostName.rawValue].stringValue
        self.maxCapacity = JSON[PartyDetailsKey.maxCapacity.rawValue].intValue
    }
    
}
