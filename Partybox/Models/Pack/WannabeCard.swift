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
    
    case type
    
    case content
    
}

class WannabeCard {
    
    // MARK: - Instance Properties
    
    var type: String
    
    var content: String
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON) {
        self.type = JSON[WannabeCardKey.type.rawValue].stringValue
        self.content = JSON[WannabeCardKey.content.rawValue].stringValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            WannabeCardKey.type.rawValue: self.type,
            WannabeCardKey.content.rawValue: self.content
        ] as [String: Any]
        
        return JSON
    }
    
}
