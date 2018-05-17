//
//  PartyDetailsNotification.swift
//  Partybox
//
//  Created by Christian Villa on 5/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum PartyDetailsNotification: String {

    // MARK: - Party Details Notifications

    case nameChanged = "PartyDetailsNotification/nameChanged"

    case gameIdChanged = "PartyDetailsNotification/gameIdChanged"

    case statusChanged = "PartyDetailsNotification/statusChanged"

    case hostNameChanged = "PartyDetailsNotification/hostNameChanged"

}
