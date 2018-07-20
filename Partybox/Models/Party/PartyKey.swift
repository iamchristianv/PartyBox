//
//  PartyKey.swift
//  Partybox
//
//  Created by Christian Villa on 5/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum PartyKey: String {

    case id

    case name

    case hostId

    case userId

    case gameId

    case persons

    case timestamp

    case wannabe = "C2D4V"

    static func gameIds() -> [String] {
        return [PartyKey.wannabe.rawValue]
    }

}
