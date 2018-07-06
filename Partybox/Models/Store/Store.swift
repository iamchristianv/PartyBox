//
//  Store.swift
//  Partybox
//
//  Created by Christian Villa on 6/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class Store {

    // MARK: - Instance Properties

    var id: String = Partybox.value.none

    var wannabePacks: OrderedSet<WannabePack> = OrderedSet<WannabePack>()

    // MARK: - Construction Functions

    static func construct() -> Store {
        let store = Store()
        store.id = Partybox.value.none
        store.wannabePacks = OrderedSet<WannabePack>()
        return store
    }

    // MARK: - Store Functions

    func open(callback: @escaping ErrorCallback) {
        // load purchases
    }

    func close(callback: @escaping ErrorCallback) {
        // save purchases
    }

    // MARK: - Pack Functions

    func fetchPacks(gameName: String, callback: @escaping (String?) -> Void) {
        if gameName == "Wannabe" && self.wannabePacks.count != 0 {
            callback(nil)
        }

        let path = "\(DatabaseKey.packs.rawValue)/\(gameName)/\(DatabaseKey.details.rawValue)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let value = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(value) {
                if gameName == "Wannabe" {
                    self.wannabePacks.add(WannabePack.construct(json: json))
                }
            }

            callback(nil)
        })
    }

    func fetchCards(gameName: String, packName: String, callback: @escaping (String?) -> Void) {
        if gameName == "Wannabe" && self.wannabePacks.fetch(key: packName)?.cards.count != 0 {
            callback(nil)
        }

        let path = "\(DatabaseKey.packs.rawValue)/\(gameName)/\(DatabaseKey.cards.rawValue)/\(packName)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let value = snapshot.value as? [[String: Any]] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(value) {
                if gameName == "Wannabe" {
                    self.wannabePacks.fetch(key: packName)?.cards.add(WannabeCard.construct(json: json))
                }
            }

            callback(nil)
        })
    }

}
