//
//  PartyNotification.swift
//  Partybox
//
//  Created by Christian Villa on 5/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum PartyNotification: String {

    case nameChanged = "PartyNotification/nameChanged"

    case hostIdChanged = "PartyNotification/hostIdChanged"

    case gameIdChanged = "PartyNotification/gameIdChanged"

    case guestAdded = "PartyNotification/guestAdded"

    case guestChanged = "PartyNotification/guestChanged"

    case guestRemoved = "PartyNotification/guestRemoved"

    case wannabeStarted = "PartyNotification/wannabeStarted"

}
