//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 1/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum GameKey: String {
    
    // MARK: - Database Keys
    
    case details
    
    case people
    
    case pack
    
}

enum GameType {
    
    // MARK: - Game Types
    
    case wannabe
    
    // MARK: - Game Type Collection
    
    static var collection: [GameType] {
        return [.wannabe]
    }
    
}

enum GameNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Game/GameDetails/detailsChanged"
    
    case peopleChanged = "Game/GamePeople/peopleChanged"
    
    case packChanged = "Game/GamePack/packChanged"
    
}

class Game {
    
    // MARK: - Instance Properties
    
    var type: GameType
    
    // MARK: - Initialization Functions
    
    init() {
        self.type = .wannabe
    }
    
    // MARK: - Database Functions
    
    func loadPackCollection(callback: @escaping (String?) -> Void) {
        switch Game.current.type {
        case .wannabe:
            Wannabe.current.loadPackCollection(callback: callback)
        }
    }
    
}
