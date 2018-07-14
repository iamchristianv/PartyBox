//
//  ChangePartyHostViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangePartyHostViewDelegate {

    func changePartyHostView(_ view: ChangePartyHostView, guestChanged guestId: String)

    func changePartyHostView(_ view: ChangePartyHostView, saveButtonPressed: Bool)

}
