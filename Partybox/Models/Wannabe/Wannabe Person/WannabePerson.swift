//
//  WannabePerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePerson: Person {
    
    // MARK: - Properties

    var id: String

    var name: String

    var points: Int

    var voteId: String

    // MARK: - Initialization Functions

    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.points = 0
        self.voteId = Partybox.value.none
    }

    init(json: JSON) {
        self.id = json[WannabePersonKey.id.rawValue].stringValue
        self.name = json[WannabePersonKey.name.rawValue].stringValue
        self.points = json[WannabePersonKey.points.rawValue].intValue
        self.voteId = json[WannabePersonKey.voteId.rawValue].stringValue
    }
    
}
