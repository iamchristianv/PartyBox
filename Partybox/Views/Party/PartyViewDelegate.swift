//
//  PartyViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewDelegate {

    // MARK: - Party View Delegate Functions

    func partyView(_ partyView: PartyView, playButtonPressed: Bool)

    func partyView(_ partyView: PartyView, changeButtonPressed: Bool)

    func partyView(_ partyView: PartyView, kickButtonPressed person: PartyPerson)

}
