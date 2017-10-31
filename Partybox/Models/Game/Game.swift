//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 10/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import FirebaseDatabase
import Foundation

enum GameKey: String {
    
    case name
    
}

class Game {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: Game.self)
    
    static let database: DatabaseReference = Database.database().reference().child(Game.name)
    
    // MARK: - Instance Properties
    
    var name: String
    
    // MARK: - Initialization Methods
    
    init(name: String) {
        self.name = name
    }
    
}
