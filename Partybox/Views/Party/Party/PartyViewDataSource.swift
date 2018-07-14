//
//  PartyViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewDataSource {

    func partyViewPartyId() -> String

    func partyViewPartyHostId() -> String

    func partyViewPartyGame() -> PartyGame

    func partyViewPartyGuestsCount() -> Int

    func partyViewPartyGuest(index: Int) -> PartyGuest

    func partyViewPartyUserId() -> String

}
