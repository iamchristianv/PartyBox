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
    
    case name
    
}

class Party {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: Party.self)
    
    // MARK: - Instance Properties
    
    var name: String
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        // for client use
        self.name = name
    }
    
    init(JSON: JSON) {
        // for server use
        self.name = JSON[PartyKey.name.rawValue].stringValue
    }
    
    func toJSON() -> [String: Any] {
        let JSON = [
            Party.name: [
                PartyKey.name.rawValue: self.name
            ]
        ]
        
        return JSON
    }
    
}
