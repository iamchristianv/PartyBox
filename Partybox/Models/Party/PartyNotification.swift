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

    case hostChanged = "PartyNotification/hostChanged"

    case guestAdded = "PartyNotification/guestAdded"

    case guestChanged = "PartyNotification/guestChanged"

    case guestRemoved = "PartyNotification/guestRemoved"

}
