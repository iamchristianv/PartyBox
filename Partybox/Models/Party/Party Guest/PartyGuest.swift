//
//  PartyGuest.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class PartyGuest: Identifiable {

    // MARK: - Remote Properties

    var id: String = Partybox.value.none

    var name: String = Partybox.value.none

    var points: Int = Partybox.value.zero

    // MARK: - Construction Functions

    static func construct(id: String, name: String) -> PartyGuest {
        let guest = PartyGuest()
        guest.id = id
        guest.name = name
        guest.points = Partybox.value.zero
        return guest
    }

    static func construct(json: JSON) -> PartyGuest {
        let guest = PartyGuest()
        guest.id = json[PartyGuestKey.id.rawValue].stringValue
        guest.name = json[PartyGuestKey.name.rawValue].stringValue
        guest.points = json[PartyGuestKey.points.rawValue].intValue
        return guest
    }

}

extension PartyGuest: Hashable {

    var hashValue: Int {
        return self.id.hashValue
    }

    static func ==(lhs: PartyGuest, rhs: PartyGuest) -> Bool {
        return lhs.id == rhs.id
    }

}
