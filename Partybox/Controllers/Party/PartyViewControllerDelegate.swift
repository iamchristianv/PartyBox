//
//  PartyViewControllerDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyViewControllerDelegate {

    // MARK: - Party View Controller Delegate Functions

    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool)

}