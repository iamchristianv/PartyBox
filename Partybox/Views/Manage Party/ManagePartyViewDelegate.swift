//
//  ManagePartyViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ManagePartyViewDelegate {

    // MARK: - Manage Party View Delegate Functions

    func managePartyView(_ managePartyView: ManagePartyView, partyHostTextFieldPressed: Bool)

    func managePartyView(_ managePartyView: ManagePartyView, saveChangesButtonPressed: Bool)

}
