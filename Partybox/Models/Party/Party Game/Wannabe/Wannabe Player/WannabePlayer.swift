//
//  WannabePlayer.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePlayer: Identifiable {
    
    // MARK: - Remote Properties

    var id: String = Partybox.value.none

    var name: String = Partybox.value.none

    var voteId: String = Partybox.value.none

    var points: Int = Partybox.value.zero

    // MARK: - Construction Functions

    static func construct(id: String, name: String) -> WannabePlayer {
        let player = WannabePlayer()
        player.id = id
        player.name = name
        player.voteId = Partybox.value.none
        player.points = Partybox.value.zero
        return player
    }

    static func construct(json: JSON) -> WannabePlayer {
        let player = WannabePlayer()
        player.id = json[WannabePlayerKey.id.rawValue].stringValue
        player.name = json[WannabePlayerKey.name.rawValue].stringValue
        player.voteId = json[WannabePlayerKey.voteId.rawValue].stringValue
        player.points = json[WannabePlayerKey.points.rawValue].intValue
        return player
    }
    
}

extension WannabePlayer: Hashable {

    var hashValue: Int {
        return self.id.hashValue
    }

    static func ==(lhs: WannabePlayer, rhs: WannabePlayer) -> Bool {
        return lhs.id == rhs.id
    }

}
