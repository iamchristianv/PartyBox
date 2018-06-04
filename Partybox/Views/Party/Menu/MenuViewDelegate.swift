//
//  MenuViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/12/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol MenuViewDelegate {

    func menuView(_ menuView: MenuView, startPartyButtonPressed: Bool)

    func menuView(_ menuView: MenuView, joinPartyButtonPressed: Bool)

    func menuView(_ menuView: MenuView, findPartyButtonPressed: Bool)

    func menuView(_ menuView: MenuView, visitStoreButtonPressed: Bool)

}
