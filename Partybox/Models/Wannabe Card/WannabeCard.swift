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

    var hint: String = Partybox.defaults.none
    
    var action: String = Partybox.defaults.none
    
    // MARK: - Construction Functions

    static func construct() -> WannabeCard {
        let card = WannabeCard()
        card.hint = Partybox.defaults.none
        card.action = Partybox.defaults.none
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

    // MARK: - Hashable Properties

    var hashValue: Int {
        return (self.hint + self.action).hashValue
    }

    // MARK: - Hashable Functions

    static func ==(lhs: WannabeCard, rhs: WannabeCard) -> Bool {
        return (lhs.hint == rhs.hint) && (lhs.action == rhs.action)
    }

}
