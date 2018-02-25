//
//  PartyPerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyPersonKey: String {
    
    // MARK: - Database Keys
    
    case points
    
    case isReady
            
}

class PartyPerson {

    // MARK: - Instance Properties
    
    var name: String
    
    var points: Int
    
    var isReady: Bool
    
    // MARK: - JSON Properties
    
    var json: [String: Any] {
        let json = [
            self.name: [
                PartyPersonKey.points.rawValue: self.points,
                PartyPersonKey.isReady.rawValue: self.isReady
            ]
        ] as [String: Any]
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.name = ""
        self.points = 0
        self.isReady = false
    }
    
    init(name: String, JSON: JSON) {
        self.name = name
        self.points = JSON[PartyPersonKey.points.rawValue].intValue
        self.isReady = JSON[PartyPersonKey.isReady.rawValue].boolValue
    }
    
}
