//
//  PartyViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewDataSource {

    // MARK: - Party View Data Source Functions

    func partyViewUserName() -> String

    func partyViewPartyId() -> String

    func partyViewHostName() -> String

    func partyViewPeopleCount() -> Int

    func partyViewPerson(index: Int) -> PartyPerson?

    func partyViewGameName() -> String

    func partyViewGameSummary() -> String

}
