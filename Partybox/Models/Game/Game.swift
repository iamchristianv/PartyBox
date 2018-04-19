//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 1/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum GameKey: String {
    
    // MARK: - Property Keys
    
    case details
    
    case people
    
    case pack
    
}

enum GameType {
    
    // MARK: - Game Types
    
    case wannabe
        
    static var collection: [GameType] {
        return [.wannabe]
    }
    
}

enum GameNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Game/detailsChanged"
    
    case peopleChanged = "Game/peopleChanged"
    
    case packChanged = "Game/packChanged"
    
}

class Game {

    // MARK: - Shared Instance

    static var current: Game = Game()
    
    // MARK: - Instance Properties
    
    var type: GameType

    var wannabe: Wannabe
    
    // MARK: - Initialization Functions
    
    init() {
        self.type = .wannabe
        self.wannabe = Wannabe()
    }
    
}
