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
    
    case name
    
    case host
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var name: String
    
    var host: String
    
    // properties for the theme colors and emojis
    
    // MARK: - Initialization Methods
    
    init(name: String, host: String) {
        self.name = name
        self.host = host
    }
    
    init(JSON: JSON) {
        self.name = JSON[PartyDetailsKey.name.rawValue].stringValue
        self.host = JSON[PartyDetailsKey.host.rawValue].stringValue
        
        Party.userHost = (Party.userName == self.host)
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            PartyDetailsKey.name.rawValue: self.name,
            PartyDetailsKey.host.rawValue: self.host
        ] as [String: Any]
        
        return JSON
    }
    
}
