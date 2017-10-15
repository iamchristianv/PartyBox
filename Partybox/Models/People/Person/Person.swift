//
//  Person.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation

enum PersonKey: String {
    
    case name = "name"
    
    case isHost = "isHost"
    
    case points = "points"
    
    case emoji = "emoji"
    
}

class Person {
    
    // MARK: - Properties
    
    var name: String
    
    var isHost: Bool
    
    var points: Int
    
    var emoji: String
    
    // MARK: - Initialization
    
    init(name: String, isHost: Bool) {
        self.name = name
        self.isHost = isHost
        self.points = 0
        self.emoji = Person.randomEmoji()
    }
    
    // MARK: - Utility
    
    static func randomEmoji() -> String {
        let emojis = ["😊"]
        
        let randomIndex = Int(arc4random())
        let randomEmoji = emojis[randomIndex % emojis.count]
        
        return randomEmoji
    }
    
}
