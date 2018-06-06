//
//  PartyViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewDelegate {

    func partyView(_ view: PartyView, playButtonPressed: Bool)

    func partyView(_ view: PartyView, changeButtonPressed: Bool)

    func partyView(_ view: PartyView, kickButtonPressed partyPersonName: String)

}
