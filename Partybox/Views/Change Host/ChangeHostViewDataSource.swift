//
//  ChangeHostViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangeHostViewDataSource {

    func changeHostViewHostName() -> String

    func changeHostViewPeopleCount() -> Int

    func changeHostViewPerson(index: Int) -> PartyPerson?

}
