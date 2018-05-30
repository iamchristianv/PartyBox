//
//  SetupWannabeDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/29/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol SetupWannabeViewDelegate {

    func setupWannabeView(_ setupWannabeView: SetupWannabeView, roundsTextFieldPressed: Bool)

    func setupWannabeView(_ setupWannabeView: SetupWannabeView, packNameTextFieldPressed: Bool)

    func setupWannabeView(_ setupWannabeView: SetupWannabeView, startButtonPressed: Bool)

}
