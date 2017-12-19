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
    
    case host
    
    case points
    
    case emoji
    
    case ready
    
}

class PartyPerson {

    // MARK: - Instance Properties
    
    var name: String
    
    var host: Bool

    var points: Int
    
    var emoji: String
    
    var ready: Bool
    
    // MARK: - Initialization Methods
    
    init(name: String, host: Bool) {
        self.name = name
        self.host = host
        self.points = 0
        self.emoji = PartyPerson.randomEmoji()
        self.ready = false
    }
    
    required init(name: String, JSON: JSON) {
        self.name = name
        self.host = JSON[PartyPersonKey.host.rawValue].boolValue
        self.points = JSON[PartyPersonKey.points.rawValue].intValue
        self.emoji = JSON[PartyPersonKey.emoji.rawValue].stringValue
        self.ready = JSON[PartyPersonKey.ready.rawValue].boolValue
        
        if self.name == Session.name {
            Session.host = self.host
        }
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            self.name: [
                PartyPersonKey.host.rawValue: self.host,
                PartyPersonKey.points.rawValue: self.points,
                PartyPersonKey.emoji.rawValue: self.emoji,
                PartyPersonKey.ready.rawValue: self.ready
            ]
        ] 
        
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
