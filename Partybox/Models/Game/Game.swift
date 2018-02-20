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
    
    // MARK: - Game Type Functions
    
    static var collection: [GameType] {
        return [.wannabe]
    }
    
}

enum GameNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Game/GameDetails/detailsChanged"
    
    case peopleChanged = "Game/GamePeople/peopleChanged"
    
}

class Game {
    
    // MARK: - Shared Instance
    
    static var current: Game = Game()
    
    // MARK: - Instance Properties
    
    static var type: GameType = .wannabe
    
    static var wannabe: Wannabe = Wannabe()
    
    // MARK: - JSON Properties
    
    static var json: [String: Any] {
        switch self.type {
        case .wannabe:
            return Game.wannabe.json
        }
    }
    
    // MARK: - Notification Functions
    
    static func startObservingChanges() {
        switch Game.type {
        case .wannabe:
            Game.wannabe.startObservingChanges()
        }
    }
    
    static func stopObservingChanges() {
        switch Game.type {
        case .wannabe:
            Game.wannabe.stopObservingChanges()
        }
    }
    
}
