//
//  PartyGame.swift
//  Partybox
//
//  Created by Christian Villa on 7/9/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class PartyGame: Identifiable {

    // MARK: - Static Properties

    static var wannabeId: String = "C2D4V"

    // MARK: - Remote Properties

    var id: String = Partybox.value.none

}

extension PartyGame: Hashable {

    var hashValue: Int {
        return self.id.hashValue
    }

    static func ==(lhs: PartyGame, rhs: PartyGame) -> Bool {
        return lhs.id == rhs.id
    }

}
