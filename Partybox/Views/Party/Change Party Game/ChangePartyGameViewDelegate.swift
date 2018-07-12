//
//  ChangePartyGameViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyGameViewDelegate {

    func changePartyGameView(_ view: ChangePartyGameView, gameChanged game: PartyGame)

    func changePartyGameView(_ view: ChangePartyGameView, saveButtonPressed: Bool)

}
