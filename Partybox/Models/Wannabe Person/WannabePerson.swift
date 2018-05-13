//
//  WannabePerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePerson {
    
    // MARK: - Instance Properties

    var name: String = Partybox.none

    var points: Int = Partybox.zero

    var vote: String = Partybox.none
    
    // MARK: - Construction Functions

    static func construct(name: String) -> WannabePerson {
        let person = WannabePerson()
        person.name = name
        person.points = Partybox.zero
        person.vote = Partybox.none
        return person
    }

    static func construct(json: JSON) -> WannabePerson {
        let person = WannabePerson()
        person.name = json[WannabePersonKey.name.rawValue].stringValue
        person.points = json[WannabePersonKey.points.rawValue].intValue
        person.vote = json[WannabePersonKey.vote.rawValue].stringValue
        return person
    }
    
}

extension WannabePerson: Hashable {

    // MARK: - Hashable Properties

    var hashValue: Int {
        return self.name.hashValue
    }

    // MARK: - Hashable Functions

    static func ==(lhs: WannabePerson, rhs: WannabePerson) -> Bool {
        return lhs.name == rhs.name
    }

}
