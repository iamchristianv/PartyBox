//
//  ChangePartyGameViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyGameViewDataSource {

    func changePartyGameViewPartyGameId() -> String

    func changePartyGameViewPartyGameCount() -> Int

    func changePartyGameViewPartyGameId(index: Int) -> String

    func changePartyGameViewPartyGameName(index: Int) -> String

}
