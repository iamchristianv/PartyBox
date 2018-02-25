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
    
    case capacity
    
    case hasAds
    
    case isClosed
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var id: String
    
    var name: String
    
    var hostName: String
    
    var capacity: Int
    
    var hasAds: Bool
    
    var isClosed: Bool
    
    // MARK: - Database Properties
    
    var json: [String: Any] {
        let json = [
            PartyDetailsKey.id.rawValue: self.id,
            PartyDetailsKey.name.rawValue: self.name,
            PartyDetailsKey.hostName.rawValue: self.hostName,
            PartyDetailsKey.capacity.rawValue: self.capacity,
            PartyDetailsKey.hasAds.rawValue: self.hasAds,
            PartyDetailsKey.isClosed.rawValue: self.isClosed
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.id = ""
        self.name = ""
        self.hostName = ""
        self.capacity = 10
        self.hasAds = true
        self.isClosed = false
    }
    
    init(JSON: JSON) {
        self.id = JSON[PartyDetailsKey.id.rawValue].stringValue
        self.name = JSON[PartyDetailsKey.name.rawValue].stringValue
        self.hostName = JSON[PartyDetailsKey.hostName.rawValue].stringValue
        self.capacity = JSON[PartyDetailsKey.capacity.rawValue].intValue
        self.hasAds = JSON[PartyDetailsKey.hasAds.rawValue].boolValue
        self.isClosed = JSON[PartyDetailsKey.isClosed.rawValue].boolValue
    }
    
}
