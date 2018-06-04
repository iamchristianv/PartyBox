//
//  PartyPerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class PartyPerson {

    // MARK: - Instance Properties

    var name: String = Partybox.values.none

    var points: Int = Partybox.values.zero

    var emoji: String = Partybox.values.none

    // MARK: - Construction Functions

    static func construct(name: String) -> PartyPerson {
        let person = PartyPerson()
        person.name = name
        person.points = Partybox.values.zero
        person.emoji = Partybox.values.randomPersonEmoji()
        return person
    }

    static func construct(json: JSON) -> PartyPerson {
        let person = PartyPerson()
        person.name = json[PartyPersonKey.name.rawValue].stringValue
        person.points = json[PartyPersonKey.points.rawValue].intValue
        person.emoji = json[PartyPersonKey.emoji.rawValue].stringValue
        return person
    }

}

extension PartyPerson: Hashable {

    var hashValue: Int {
        return self.name.hashValue
    }

    static func ==(lhs: PartyPerson, rhs: PartyPerson) -> Bool {
        return lhs.name == rhs.name
    }

}
