//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 5/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class Game {

    // MARK: - Instance Properties

    var wannabe: Wannabe = Wannabe()

    // MARK: - Construction Functions

    static func construct(party: String) -> Game {
        let game = Game()
        game.wannabe = Wannabe.construct(party: party)
        return game
    }

}
