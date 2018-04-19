//
//  WannabeCard.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabeCardKey: String {
    
    // MARK: - Property Keys
    
    case type
    
    case hint
    
    case action
    
}

class WannabeCard {
    
    // MARK: - Instance Properties
    
    var type: String
    
    var hint: String
    
    var action: String
    
    // MARK: - Initialization Functions

    init() {
        self.type = ""
        self.hint = ""
        self.action = ""
    }
    
    init(JSON: JSON) {
        self.type = JSON[WannabeCardKey.type.rawValue].stringValue
        self.hint = JSON[WannabeCardKey.hint.rawValue].stringValue
        self.action = JSON[WannabeCardKey.action.rawValue].stringValue
    }
    
}
