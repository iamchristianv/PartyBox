//
//  WannabePack.swift
//  Partybox
//
//  Created by Christian Villa on 5/5/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class WannabePack {

    // MARK: - Instance Properties

    var id: String = Partybox.none

    var name: String = Partybox.none

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    private var dataSource: WannabePackDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabePackDataSource) -> WannabePack {
        let pack = WannabePack()
        pack.id = Partybox.none
        pack.name = Partybox.none
        pack.cards = OrderedSet<WannabeCard>()
        pack.dataSource = dataSource
        return pack
    }

    static func construct(json: JSON, dataSource: WannabePackDataSource) -> WannabePack {
        let pack = WannabePack()
        pack.id = json[WannabePackKey.id.rawValue].stringValue
        pack.name = json[WannabePackKey.name.rawValue].stringValue
        pack.cards = OrderedSet<WannabeCard>()
        pack.dataSource = dataSource
        return pack
    }

    // MARK: - Pack Functions

    func fetchCards(callback: @escaping (String?) -> Void) {
        let path = self.dataSource.wannabePackPath()

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let json = JSON(data)

            for (_, value) in json {
                let card = WannabeCard.construct(json: value)
                self.cards.add(card)
            }

            callback(nil)
        })
    }

}

extension WannabePack: Hashable {

    // MARK: - Hashable Properties

    var hashValue: Int {
        return self.id.hashValue
    }

    // MARK: - Hashable Functions

    static func ==(lhs: WannabePack, rhs: WannabePack) -> Bool {
        return lhs.id == rhs.id
    }

}
