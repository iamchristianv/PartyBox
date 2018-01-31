//
//  Wannabe.swift
//  Partybox
//
//  Created by Christian Villa on 11/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabeKey: String {
    
    case details
    
    case pack
            
    case people
    
}

class Wannabe: Game {
    
    // MARK: - Instance Properties
    
    var details: WannabeDetails
    
    var pack: WannabePack
    
    var people: WannabePeople
    
    // MARK: - Initialization Functions
    
    required init(JSON: JSON) {
        self.details = WannabeDetails(JSON: JSON[WannabeKey.details.rawValue])
        self.pack = WannabePack(JSON: JSON[WannabeKey.pack.rawValue])
        self.people = WannabePeople(JSON: JSON[WannabeKey.people.rawValue])
    }
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String: Any] {
        let JSON = [
            WannabeKey.details.rawValue: self.details.toJSON(),
            WannabeKey.people.rawValue: self.people.toJSON()
        ]
        
        return JSON
    }
    
}
