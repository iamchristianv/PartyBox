//
//  SetupWannabeViewDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol SetupWannabeViewDelegate {

    func setupWannabeView(_ view: SetupWannabeView, packSelected packId: String)

    func setupWannabeView(_ view: SetupWannabeView, saveButtonPressed: Bool)

}
