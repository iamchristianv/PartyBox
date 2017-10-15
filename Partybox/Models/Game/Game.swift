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
    
    case name = "name"
    
}

class Game {
    
    // MARK: - Database Reference
    
    static let database: DatabaseReference = Database.database().reference().child(String(describing: Game.self))
    
    // MARK: - Properties
    
    var name: String?
    
    // MARK: - Initialization
    
    init(name: String) {
        self.name = name
    }
    
}
