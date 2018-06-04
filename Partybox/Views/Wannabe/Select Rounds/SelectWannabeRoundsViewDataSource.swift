//
//  SelectWannabeRoundsViewDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol SelectWannabeRoundsViewDataSource {

    func selectWannabeRoundsViewRoundsCount() -> Int

    func selectWannabeRoundsViewRounds(index: Int) -> Int

}
