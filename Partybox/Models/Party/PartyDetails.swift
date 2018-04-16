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
    
    // MARK: - Property Keys
    
    case id
    
    case name

    case status

    case value
    
    case hostId
    
    case timestamp
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var id: String
    
    var name: String

    var status: String

    var value: Any?
    
    var hostId: String

    var timestamp: Int
    
    // MARK: - Initialization Functions
    
    init() {
        self.id = ""
        self.name = ""
        self.status = PartyStatus.waiting.rawValue
        self.value = nil
        self.hostId = ""
        self.timestamp = 0
    }

    init(JSON: JSON) {
        self.id = JSON[PartyDetailsKey.id.rawValue].stringValue
        self.name = JSON[PartyDetailsKey.name.rawValue].stringValue
        self.status = JSON[PartyDetailsKey.status.rawValue].stringValue
        self.value = JSON[PartyDetailsKey.value.rawValue].object
        self.hostId = JSON[PartyDetailsKey.hostId.rawValue].stringValue
        self.timestamp = JSON[PartyDetailsKey.timestamp.rawValue].intValue
    }
    
}
