//
//  WannabeCard.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabeCard: Card {

    // MARK: - Properties

    var id: String

    var clue: String
    
    var move: String
    
    // MARK: - Initialization Functions

    init(json: JSON) {
        self.id = json[WannabeCardKey.id.rawValue].stringValue
        self.clue = json[WannabeCardKey.clue.rawValue].stringValue
        self.move = json[WannabeCardKey.move.rawValue].stringValue
    }
    
}
