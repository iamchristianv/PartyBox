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
    
    var name: String
    
    var points: Int
    
    var emoji: String
    
    var ready: Bool
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        self.name = name
        self.points = 0
        self.emoji = PartyPerson.randomEmoji()
        self.ready = false
    }
    
    required init(name: String, JSON: JSON) {
        self.name = name
        self.points = JSON[PartyPersonKey.points.rawValue].intValue
        self.emoji = PartyPerson.randomEmoji()
        self.ready = JSON[PartyPersonKey.ready.rawValue].boolValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            self.name: [
                PartyPersonKey.points.rawValue: self.points,
                PartyPersonKey.ready.rawValue: self.ready
            ]
        ] as [String: Any]
        
        return JSON
    }
    
    // MARK: - Utility Methods
    
    static func randomEmoji() -> String {
        let emojis = ["😊"]
        
        let randomIndex = Int(arc4random())
        let randomEmoji = emojis[randomIndex % emojis.count]
        
        return randomEmoji
    }
    
}
