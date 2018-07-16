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

    // MARK: - Local Properties

    var purchasedIds: Set<String> = Set<String>()

    var wannabePacks: OrderedSet<WannabePack> = OrderedSet<WannabePack>()

    // MARK: - Construction Functions

    static func construct() -> Store {
        let store = Store()
        store.purchasedIds = Set<String>()
        store.wannabePacks = OrderedSet<WannabePack>()
        return store
    }

    // MARK: - Store Functions

    func loadPurchases() {
        // access user defaults
    }

    func restorePurchases() {
        // access apple api
    }

    // MARK: - Pack Functions

    func fetchTitles(gameId: String, callback: @escaping (_ error: String?) -> Void) {
        if gameId == PartyGame.wannabeId && self.wannabePacks.count != 0 {
            callback(nil)
        }

        let path = "\(PartyboxKey.store.rawValue)/\(gameId)/\(StoreKey.titles.rawValue)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(data) {
                if gameId == PartyGame.wannabeId {
                    let pack = WannabePack.construct(json: json)
                    self.wannabePacks.add(pack)
                }
            }

            callback(nil)
        })
    }

    func fetchCards(gameId: String, packId: String, callback: @escaping (_ error: String?) -> Void) {
        if gameId == PartyGame.wannabeId && self.wannabePacks[packId]?.cards.count != 0 {
            callback(nil)
        }

        let path = "\(PartyboxKey.store.rawValue)/\(gameId)/\(StoreKey.cards.rawValue)/\(packId)"

        Partybox.firebase.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [[String: Any]] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(data) {
                if gameId == PartyGame.wannabeId {
                    let card = WannabeCard.construct(json: json)
                    self.wannabePacks[packId]?.cards.add(card)
                }
            }

            callback(nil)
        })
    }

}
