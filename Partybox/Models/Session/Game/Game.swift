//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

enum GameKey: String {
    
    case name
    
}

class Game {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: Game.self)
    
    // MARK: - Instance Properties
    
    var name: String
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        // for client use
        self.name = name
    }
    
    init(JSON: JSON) {
        // for server use
        self.name = JSON[GameKey.name.rawValue].stringValue
    }
    
    func toJSON() -> [String: Any] {
        let JSON = [
            Game.name: [
                GameKey.name.rawValue: self.name
            ]
        ]
        
        return JSON
    }
    
}
