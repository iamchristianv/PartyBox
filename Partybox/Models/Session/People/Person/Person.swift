//
//  Person.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PersonKey: String {
    
    case name
    
    case isHost
    
    case points
    
    case emoji
    
}

class Person {
    
    // MARK: - Instance Properties
    
    var name: String
    
    var isHost: Bool
    
    var points: Int 
    
    var emoji: String
    
    // MARK: - Initialization Methods
    
    init(name: String, isHost: Bool) {
        // for client use
        self.name = name
        self.isHost = isHost
        self.points = 0
        self.emoji = Person.randomEmoji()
    }
    
    init(name: String, JSON: JSON) {
        // for server use
        self.name = name
        self.isHost = JSON[PersonKey.isHost.rawValue].boolValue
        self.points = JSON[PersonKey.points.rawValue].intValue
        self.emoji = JSON[PersonKey.emoji.rawValue].stringValue
    }
    
    func toJSON() -> [String: Any] {
        let JSON = [
            self.name: [
                PersonKey.isHost.rawValue: self.isHost,
                PersonKey.points.rawValue: self.points,
                PersonKey.emoji.rawValue: self.emoji
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
