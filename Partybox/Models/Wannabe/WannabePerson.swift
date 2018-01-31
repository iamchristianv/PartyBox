//
//  WannabePerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabePersonKey: String {
    
    case name
    
    case points
    
    case vote
    
}

class WannabePerson {
    
    // MARK: - Instance Properties
    
    var name: String
    
    var points: Int
    
    var vote: String
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        self.name = name
        self.points = 0
        self.vote = ""
    }
    
    init(name: String, JSON: JSON) {
        self.name = name
        self.points = JSON[WannabePersonKey.points.rawValue].intValue
        self.vote = JSON[WannabePersonKey.vote.rawValue].stringValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            self.name: [
                WannabePersonKey.points.rawValue: self.points,
                WannabePersonKey.vote.rawValue: self.vote
            ]
        ] as [String: Any]
        
        return JSON
    }
    
}
