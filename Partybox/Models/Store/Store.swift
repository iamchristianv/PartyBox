//
//  Store.swift
//  Partybox
//
//  Created by Christian Villa on 6/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class Store {

    static var activityIds: [String] = []

    static var packIds: Set<String> = Set<String>()

    // MARK: - Properties

    var wannabe: Wannabe

    var wannabePacks: OrderedSet<WannabePack>

    // MARK: - Initialization Functions

    init() {
        self.wannabe = Wannabe(partyId: Partybox.value.none)
        self.wannabePacks = OrderedSet<WannabePack>()
        Store.activityIds.append(self.wannabe.id)
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
        if gameId == self.wannabe.id && self.wannabePacks.count != 0 {
            callback(nil)
        }

        let path = "\(PartyboxKey.store.rawValue)/\(gameId)/\(StoreKey.titles.rawValue)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(data) {
                if gameId == self.wannabe.id {
                    let pack = WannabePack(json: json)
                    self.wannabePacks.add(pack)
                }
            }

            callback(nil)
        })
    }

    func fetchCards(gameId: String, packId: String, callback: @escaping (_ error: String?) -> Void) {
        if gameId == self.wannabe.id && self.wannabePacks[packId]?.cards.count != 0 {
            callback(nil)
        }

        let path = "\(PartyboxKey.store.rawValue)/\(gameId)/\(StoreKey.cards.rawValue)/\(packId)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [[String: Any]] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            for (_, json) in JSON(data) {
                if gameId == self.wannabe.id {
                    let card = WannabeCard(json: json)
                    self.wannabePacks[packId]?.cards.add(card)
                }
            }

            callback(nil)
        })
    }

}
