//
//  WannabeGame.swift
//  Partybox
//
//  Created by Christian Villa on 11/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabeGameKey: String {
    
    case details
    
    case pack
            
    case people
    
}

class WannabeGame {
    
    // MARK: - Instance Properties
    
    var details: WannabeDetails
    
    var pack: WannabePack
    
    var people: WannabePeople
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON) {
        self.details = WannabeDetails(JSON: JSON[WannabeGameKey.details.rawValue])
        self.pack = WannabePack(JSON: JSON[WannabeGameKey.pack.rawValue])
        self.people = WannabePeople(JSON: JSON[WannabeGameKey.people.rawValue])
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            WannabeGameKey.details.rawValue: self.details.toJSON(),
            WannabeGameKey.people.rawValue: self.people.toJSON()
        ] as [String: Any]
        
        return JSON
    }
    
}
