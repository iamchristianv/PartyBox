//
//  ChangePartyHostViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyHostViewDataSource {

    func changePartyHostViewPartyHostId() -> String

    func changePartyHostViewPartyGuestsCount() -> Int

    func changePartyHostViewPartyGuest(index: Int) -> PartyGuest

}
