//
//  WannabeCard.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabeCard {
    
    // MARK: - Instance Properties

    var hint: String = Partybox.values.none
    
    var action: String = Partybox.values.none
    
    // MARK: - Construction Functions

    static func construct() -> WannabeCard {
        let card = WannabeCard()
        card.hint = Partybox.values.none
        card.action = Partybox.values.none
        return card
    }

    static func construct(json: JSON) -> WannabeCard {
        let card = WannabeCard()
        card.hint = json[WannabeCardKey.hint.rawValue].stringValue
        card.action = json[WannabeCardKey.action.rawValue].stringValue
        return card
    }
    
}

extension WannabeCard: Hashable {

    var hashValue: Int {
        return (self.hint + self.action).hashValue
    }

    static func ==(lhs: WannabeCard, rhs: WannabeCard) -> Bool {
        return (lhs.hint == rhs.hint) && (lhs.action == rhs.action)
    }

}
