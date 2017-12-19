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
    
}

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var name: String
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        self.name = name
    }
    
    init(JSON: JSON) {
        self.name = JSON[PartyDetailsKey.name.rawValue].stringValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            PartyDetailsKey.name.rawValue: self.name
        ] as [String: Any]
        
        return JSON
    }
    
}
