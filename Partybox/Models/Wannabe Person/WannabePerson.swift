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

    var name: String = Partybox.defaults.none

    var points: Int = Partybox.defaults.zero

    var voteName: String = Partybox.defaults.none
    
    // MARK: - Construction Functions

    static func construct(name: String) -> WannabePerson {
        let person = WannabePerson()
        person.name = name
        person.points = Partybox.defaults.zero
        person.voteName = Partybox.defaults.none
        return person
    }

    static func construct(json: JSON) -> WannabePerson {
        let person = WannabePerson()
        person.name = json[WannabePersonKey.name.rawValue].stringValue
        person.points = json[WannabePersonKey.points.rawValue].intValue
        person.voteName = json[WannabePersonKey.voteName.rawValue].stringValue
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
