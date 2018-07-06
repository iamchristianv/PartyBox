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

    var name: String = Partybox.value.none

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    // MARK: - Construction Functions

    static func construct() -> WannabePack {
        let pack = WannabePack()
        pack.name = Partybox.value.none
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

    static func construct(json: JSON) -> WannabePack {
        let pack = WannabePack()
        pack.name = json[WannabePackKey.name.rawValue].stringValue
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

}

extension WannabePack: Hashable {

    var hashValue: Int {
        return self.name.hashValue
    }

    static func ==(lhs: WannabePack, rhs: WannabePack) -> Bool {
        return lhs.name == rhs.name
    }

}
