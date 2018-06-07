//
//  PartyDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/27/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyDataSource {

    func partyUserName() -> String

    func partyUserPath() -> String

    func partyPartyPath() -> String

    func partyPartyDetailsPath() -> String

    func partyPartyPeoplePath() -> String

}