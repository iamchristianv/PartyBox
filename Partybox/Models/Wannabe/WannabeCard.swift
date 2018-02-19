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
    
    // MARK: - Database Keys
    
    case type
    
    case hint
    
    case content
    
}

class WannabeCard {
    
    // MARK: - Instance Properties
    
    var type: String = ""
    
    var hint: String = ""
    
    var content: String = ""
    
    // MARK: - JSON Properties
    
    var json: [String: Any] {
        let json = [
            WannabeCardKey.type.rawValue: self.type,
            WannabeCardKey.hint.rawValue: self.hint,
            WannabeCardKey.content.rawValue: self.content
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init(JSON: JSON) {
        self.type = JSON[WannabeCardKey.type.rawValue].stringValue
        self.hint = JSON[WannabeCardKey.hint.rawValue].stringValue
        self.content = JSON[WannabeCardKey.content.rawValue].stringValue
    }
    
}
