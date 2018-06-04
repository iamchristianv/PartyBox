//
//  ChangeGameViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol ChangeGameViewDataSource {

    func changeGameViewGameId() -> String

    func changeGameViewGameCount() -> Int

    func changeGameViewGameId(index: Int) -> String

    func changeGameViewGameName(index: Int) -> String

}
