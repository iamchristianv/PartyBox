//
//  PartyGame.swift
//  Partybox
//
//  Created by Christian Villa on 7/9/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class PartyGame: Event {

    // MARK: - Static Properties

    static var wannabeId: String = "C2D4V"

    // MARK: - Local Properties

    var partyId: String = Partybox.value.none

    var summary: String = Partybox.value.none

    var instructions: String = Partybox.value.none

}
