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

class WannabePack: Pack {

    // MARK: - Properties

    var id: String

    var name: String

    var summary: String

    var cards: OrderedSet<WannabeCard>

    // MARK: - Initialization Functions

    init(json: JSON) {
        self.id = json[WannabePackKey.id.rawValue].stringValue
        self.name = json[WannabePackKey.name.rawValue].stringValue
        self.summary = json[WannabePackKey.summary.rawValue].stringValue
        self.cards = OrderedSet<WannabeCard>()
    }

}
