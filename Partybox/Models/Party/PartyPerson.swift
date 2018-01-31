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
    
    case name
    
    case points
    
    case ready
    
}

class PartyPerson {

    // MARK: - Instance Properties
    
    var name: String = ""
    
    var points: Int = 0
    
    var emoji: String = PartyPerson.randomEmoji()
    
    var ready: Bool = false
    
    // MARK: - Initialization Functions
    
    init(name: String) {
        self.name = name
        self.points = 0
        self.emoji = PartyPerson.randomEmoji()
        self.ready = false
    }
    
    init(name: String, JSON: JSON) {
        self.name = name
        self.points = JSON[PartyPersonKey.points.rawValue].intValue
        self.emoji = PartyPerson.randomEmoji()
        self.ready = JSON[PartyPersonKey.ready.rawValue].boolValue
    }
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String: Any] {
        let JSON = [
            self.name: [
                PartyPersonKey.points.rawValue: self.points,
                PartyPersonKey.ready.rawValue: self.ready
            ]
        ]
        
        return JSON
    }
    
    // MARK: - Utility Functions
    
    static func randomEmoji() -> String {
        let emojis = ["😊"]
        
        let randomIndex = Int(arc4random())
        let randomEmoji = emojis[randomIndex % emojis.count]
        
        return randomEmoji
    }
    
}
