//
//  WannabeDataSource.swift
//  Partybox
//
//  Created by Christian Villa on 5/27/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol WannabeDataSource {

    func wannabeUserName() -> String

    func wannabeUserPath() -> String

    func wannabeWannabePath() -> String

    func wannabeWannabeDetailsPath() -> String

    func wannabeWannabePeoplePath() -> String

}
