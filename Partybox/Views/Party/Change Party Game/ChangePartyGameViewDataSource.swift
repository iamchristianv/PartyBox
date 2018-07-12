//
//  ChangePartyGameViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyGameViewDataSource {

    func changePartyGameViewPartyGame() -> PartyGame

    func changePartyGameViewPartyGamesCount() -> Int

    func changePartyGameViewPartyGame(index: Int) -> PartyGame?

}
