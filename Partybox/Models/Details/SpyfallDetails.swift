//
//  SpyfallDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SpyfallDetailsKey: String {
    
    case code
        
    case name
    
    case setup
    
    case ready
    
    case duration
    
}

class SpyfallDetails {
    
    // MARK: - Instance Properties
    
    var code: String = "CV24"
    
    var name: String = "🕵🏼 Spyfall"
    
    var summary: String = "Everyone knows what the secret is, except for one person: the spy! Find out who the spy is!"
    
    var instructions: String = "This is how you play Spyfall\n\nYou have to do this\n\nAnd this\n\nAnd this, too"
    
    var setup: Bool
    
    var ready: Bool
    
    var duration: Int
    
    // MARK: - Initialization Methods
    
    init() {
        self.setup = false
        self.ready = false
        self.duration = 0
    }
    
    init(JSON: JSON) {
        self.setup = JSON[SpyfallDetailsKey.setup.rawValue].boolValue
        self.ready = JSON[SpyfallDetailsKey.ready.rawValue].boolValue
        self.duration = JSON[SpyfallDetailsKey.duration.rawValue].intValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            SpyfallDetailsKey.code.rawValue: self.code,
            SpyfallDetailsKey.setup.rawValue: self.setup,
            SpyfallDetailsKey.ready.rawValue: self.ready,
            SpyfallDetailsKey.duration.rawValue: self.duration
        ] as [String : Any]
        
        return JSON
    }
    
}
