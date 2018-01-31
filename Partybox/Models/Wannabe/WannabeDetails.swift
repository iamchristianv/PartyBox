//
//  WannabeDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabeDetailsKey: String {
    
    case id
    
    case setup
    
    case ready
    
    case rounds
    
    case wannabe
    
    case card
    
}

class WannabeDetails: GameDetails {
    
    // MARK: - Instance Properties
    
    var id: String = "AS12"
    
    var name: String = "Wannabe"
    
    var summary: String = "Everyone knows what the secret is, except for one person: the wannabe! Find out who the wannabe is!"
    
    var instructions: String = "This is how you play Wannabe\n\nYou have to do this\n\nAnd this\n\nAnd this, too"
    
    var setup: Bool = false // settingsReady or readyToStart
    
    var ready: Bool = false // peopleReady or readyToPlay
    
    var rounds: Int = 0
    
    var roundLength: Int = 10
    
    var wannabe: String = ""
    
    var card: WannabeCard = WannabeCard(JSON: JSON(""))
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON) {
        self.setup = JSON[WannabeDetailsKey.setup.rawValue].boolValue
        self.ready = JSON[WannabeDetailsKey.ready.rawValue].boolValue
        self.rounds = JSON[WannabeDetailsKey.rounds.rawValue].intValue
        self.wannabe = JSON[WannabeDetailsKey.wannabe.rawValue].stringValue
        self.card = WannabeCard(JSON: JSON[WannabeDetailsKey.card.rawValue])
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            WannabeDetailsKey.id.rawValue: self.id,
            WannabeDetailsKey.setup.rawValue: self.setup,
            WannabeDetailsKey.ready.rawValue: self.ready,
            WannabeDetailsKey.rounds.rawValue: self.rounds,
            WannabeDetailsKey.wannabe.rawValue: self.wannabe,
            WannabeDetailsKey.card.rawValue: self.card.toJSON()
        ] as [String : Any]
        
        return JSON
    }
    
}
