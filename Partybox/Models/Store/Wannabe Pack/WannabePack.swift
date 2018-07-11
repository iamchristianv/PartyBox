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

class WannabePack: Identifiable {

    // MARK: - Remote Properties

    var name: String = Partybox.value.none

    var summary: String = Partybox.value.none

    var cards: OrderedSet<WannabeCard> = OrderedSet<WannabeCard>()

    // MARK: - Construction Functions

    static func construct() -> WannabePack {
        let pack = WannabePack()
        pack.id = Partybox.value.none
        pack.name = Partybox.value.none
        pack.summary = Partybox.value.none
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

    static func construct(json: JSON) -> WannabePack {
        let pack = WannabePack()
        pack.id = json[WannabePackKey.id.rawValue].stringValue
        pack.name = json[WannabePackKey.name.rawValue].stringValue
        pack.summary = json[WannabePackKey.summary.rawValue].stringValue
        pack.cards = OrderedSet<WannabeCard>()
        return pack
    }

}
