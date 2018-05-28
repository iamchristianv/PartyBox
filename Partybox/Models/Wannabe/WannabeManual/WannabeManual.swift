//
//  WannabeManual.swift
//  Partybox
//
//  Created by Christian Villa on 5/27/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class WannabeManual {

    // MARK: - Instance Properties

    var summary: String = Partybox.values.none

    var instructions: String = Partybox.values.none

    // MARK: - Construction Functions

    static func construct() -> WannabeManual {
        let manual = WannabeManual()
        manual.summary = "Wannabe Summary"
        manual.instructions = "Wannabe Instructions"
        return manual
    }

}
