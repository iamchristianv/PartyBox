//
//  ChangePartyHostViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyHostViewDataSource {

    func changePartyHostViewHostName() -> String

    func changePartyHostViewPeopleCount() -> Int

    func changePartyHostViewPerson(index: Int) -> PartyPerson?

}
