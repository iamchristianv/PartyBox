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
    
    case pack
    
}

enum GameNotification: String {
    
    // MARK: - Notification Types
    
    case detailsChanged = "Game/GameDetails/detailsChanged"
    
    case peopleChanged = "Game/GamePeople/peopleChanged"
    
    case packChanged = "Game/GamePack/packChanged"
    
}

class Game {
    
    // MARK: - Shared Instance
    
    static var current: Game = Game()
    
    // MARK: - Instance Properties
    
    var type: GameType
    
    // MARK: - JSON Properties
    
    var json: [String: Any] {
        switch Game.current.type {
        case .wannabe:
            return Wannabe.current.json
        }
    }
    
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
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        switch Game.current.type {
        case .wannabe:
            Wannabe.current.startObservingChanges()
        }
    }
    
    func stopObservingChanges() {
        switch Game.current.type {
        case .wannabe:
            Wannabe.current.stopObservingChanges()
        }
    }
    
}
