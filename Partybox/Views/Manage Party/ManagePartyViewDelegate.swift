//
//  ManagePartyViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ManagePartyViewDelegate {

    func managePartyView(_ managePartyView: ManagePartyView, hostNameTextFieldPressed: Bool)

    func managePartyView(_ managePartyView: ManagePartyView, saveButtonPressed: Bool)

}
