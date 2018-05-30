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

    var id: String = Partybox.values.none

    var name: String = Partybox.values.none

    var plays: Int = Partybox.values.zero

    var reviews: Int = Partybox.values.zero

    var rating: Int = Partybox.values.zero

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    // MARK: - Construction Functions

    static func construct() -> WannabePack {
        let pack = WannabePack()
        pack.id = Partybox.values.none
        pack.name = Partybox.values.none
        pack.plays = Partybox.values.zero
        pack.reviews = Partybox.values.zero
        pack.rating = Partybox.values.zero
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

    static func construct(json: JSON) -> WannabePack {
        let pack = WannabePack()
        pack.id = json[WannabePackKey.id.rawValue].stringValue
        pack.name = json[WannabePackKey.name.rawValue].stringValue
        pack.plays = json[WannabePackKey.plays.rawValue].intValue
        pack.reviews = json[WannabePackKey.reviews.rawValue].intValue
        pack.rating = json[WannabePackKey.ratings.rawValue].intValue
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

}

extension WannabePack: Hashable {

    var hashValue: Int {
        return self.id.hashValue
    }

    static func ==(lhs: WannabePack, rhs: WannabePack) -> Bool {
        return lhs.id == rhs.id
    }

}
