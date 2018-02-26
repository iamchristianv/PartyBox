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
    
    // MARK: - Database Keys
    
    case details
    
    case people
    
    case pack
    
}

class Wannabe {
    
    // MARK: - Instance Properties
        
    var details: WannabeDetails
    
    var people: WannabePeople
    
    var pack: WannabePack
    
    // MARK: - JSON Properties
    
    var json: [String: Any] { 
        let json = [
            self.details.id: [
                WannabeKey.details.rawValue: self.details.json,
                WannabeKey.people.rawValue: self.people.json,
                WannabeKey.pack.rawValue: self.pack.json
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.details = WannabeDetails()
        self.people = WannabePeople()
        self.pack = WannabePack()
    }
    
}
