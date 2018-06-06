//
//  ManagePartyViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ManagePartyViewDelegate {

    func managePartyView(_ view: ManagePartyView, partyHostNameTextFieldPressed: Bool)

    func managePartyView(_ view: ManagePartyView, saveButtonPressed: Bool)

}
