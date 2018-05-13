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

    func partyViewPartyHost() -> String

    func partyViewPartyPeopleCount() -> Int

    func partyViewPartyPerson(index: Int) -> PartyPerson?

    func partyViewPartyGameName() -> String

    func partyViewPartyGameSummary() -> String

}
