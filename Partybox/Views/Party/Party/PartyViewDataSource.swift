//
//  PartyViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewDataSource {

    func partyViewUserName() -> String

    func partyViewPartyId() -> String

    func partyViewPartyHostName() -> String

    func partyViewPartyPeopleCount() -> Int

    func partyViewPartyPerson(index: Int) -> PartyPerson?

    func partyViewGameName() -> String

    func partyViewGameSummary() -> String

}
