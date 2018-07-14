//
//  Event.swift
//  Partybox
//
//  Created by Christian Villa on 7/14/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class Event: Identifiable {

    // MARK: - Remote Properties

    var name: String = Partybox.value.none

    var timestamp: Int = Partybox.value.zero

    // MARK: - Local Properties

    var userId: String = Partybox.value.none

}
