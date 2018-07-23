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

    func partyViewPartyUserId() -> String

    func partyViewPartyHostId() -> String

    func partyViewPartyPersonsCount() -> Int

    func partyViewPartyPersonId(index: Int) -> String

    func partyViewPartyPersonName(index: Int) -> String

    func partyViewPartyPersonPoints(index: Int) -> Int

    func partyViewGameName() -> String

    func partyViewGameSummary() -> String

}
