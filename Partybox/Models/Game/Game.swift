//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 5/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class Game {

    // MARK: - Instance Properties

    var wannabe: Wannabe = Wannabe()

    var wannabePacks: OrderedSet<WannabePack> = OrderedSet<WannabePack>()

    // MARK: - Construction Functions

    static func construct(partyId: String) -> Game {
        let game = Game()
        game.wannabe = Wannabe.construct(partyId: partyId)
        game.wannabePacks = OrderedSet<WannabePack>()
        return game
    }

    // MARK: - Game Functions

    func fetchPacks(id: String, callback: @escaping (String?) -> Void) {
        if id == self.wannabe.details.id && self.wannabePacks.count != 0 {
            callback(nil)
        }

        let path = "\(DatabaseKey.setups.rawValue)/\(SetupKey.games.rawValue)/\(id)/\(SetupKey.packs.rawValue)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let json = JSON(data)

            for (_, value) in json {
                if id == self.wannabe.details.id {
                    let pack = WannabePack.construct(json: value, dataSource: self.wannabe)
                    self.wannabePacks.add(pack)
                }
            }

            callback(nil)
        })
    }

}
