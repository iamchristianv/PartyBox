//
//  ChangePartyHostViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyHostViewDataSource {

    func changePartyHostViewPartyHostName() -> String

    func changePartyHostViewPartyPeopleCount() -> Int

    func changePartyHostViewPartyPerson(index: Int) -> PartyPerson?

}
