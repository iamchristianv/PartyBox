//
//  PartyPerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PartyPerson: Person {

    // MARK: - Properties

    var id: String

    var name: String

    var points: Int

    // MARK: - Initialization Functions

    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.points = 0
    }

    init(json: JSON) {
        self.id = json[PartyPersonKey.id.rawValue].stringValue
        self.name = json[PartyPersonKey.name.rawValue].stringValue
        self.points = json[PartyPersonKey.points.rawValue].intValue
    }

}
