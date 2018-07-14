//
//  WannabeCard.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabeCard: Identifiable {
    
    // MARK: - Remote Properties

    var clue: String = Partybox.value.none
    
    var move: String = Partybox.value.none
    
    // MARK: - Construction Functions

    static func construct() -> WannabeCard {
        let card = WannabeCard()
        card.id = Partybox.value.none
        card.clue = Partybox.value.none
        card.move = Partybox.value.none
        return card
    }

    static func construct(json: JSON) -> WannabeCard {
        let card = WannabeCard()
        card.id = json[WannabeCardKey.id.rawValue].stringValue
        card.clue = json[WannabeCardKey.clue.rawValue].stringValue
        card.move = json[WannabeCardKey.move.rawValue].stringValue
        return card
    }
    
}
