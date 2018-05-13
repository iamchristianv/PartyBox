//
//  MenuViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol MenuViewDelegate {

    // MARK: - Menu View Delegate Functions

    func menuView(_ menuView: MenuView, startPartyButtonPressed: Bool)

    func menuView(_ menuView: MenuView, joinPartyButtonPressed: Bool)

}
