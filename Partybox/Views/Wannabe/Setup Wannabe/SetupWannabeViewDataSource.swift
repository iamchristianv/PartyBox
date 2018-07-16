//
//  SetupWannabeViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol SetupWannabeViewDataSource {

    func setupWannabeViewGamePackId() -> String

    func setupWannabeViewGamePacksCount() -> Int

    func setupWannabeViewGamePack(index: Int) -> WannabePack

}
