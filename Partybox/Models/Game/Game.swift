//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 1/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum GameType {
    
    // MARK: - Game Types
    
    case wannabe
    
    // MARK: - Game Type Properties
    
    static var collection: [GameType] {
        return [.wannabe]
    }
    
}

enum GameKey: String {
    
    // MARK: - Database Keys
    
    case details
    
    case people
    
}

class Game {
    
    // MARK: - Shared Instance
    
    static var current: Game = Game()
    
    // MARK: - Instance Properties
    
    var type: GameType
    
    var wannabe: Wannabe
    
    // MARK: - JSON Properties
    
    var json: [String: Any] {
        switch self.type {
        case .wannabe:
            return self.wannabe.json
        }
    }
    
    // MARK: - Initialization Functions
    
    init() {
        self.type = .wannabe
        self.wannabe = Wannabe()
    }
    
}
