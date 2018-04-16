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
    
    // MARK: - Property Keys

    case id

    case name

    case status

    case value

    case rounds

    case wannabeId

    case timestamp
        
}

enum WannabeStatus: String {

    // MARK: - Status Types

    case waiting = "Waiting"

}

enum WannabeRounds: Int {
    
    // MARK: - Round Types
    
    case three = 3
    
    case five = 5
    
    case seven = 7

    static var collection: [WannabeRounds] {
        return [.three, .five, .seven]
    }
    
}

class WannabeDetails {    
    
    // MARK: - Instance Properties
    
    var id: String
    
    var name: String
    
    var status: String

    var value: Any?
    
    var rounds: Int
    
    var wannabeId: String

    var timestamp: Int

    var summary: String = "Everyone knows what the secret is, except for one person: the wannabe! Find out who the wannabe is!"

    var instructions: String = "Wannabe Instructions"
    
    // MARK: - Initialization Functions
    
    init() {
        self.id = "C2D4V"
        self.name = "Wannabe"
        self.status = WannabeStatus.waiting.rawValue
        self.value = nil
        self.rounds = WannabeRounds.three.rawValue
        self.wannabeId = ""
        self.timestamp = 0
    }
    
    init(JSON: JSON) {
        self.id = JSON[WannabeDetailsKey.id.rawValue].stringValue
        self.name = JSON[WannabeDetailsKey.name.rawValue].stringValue
        self.status = JSON[WannabeDetailsKey.status.rawValue].stringValue
        self.value = JSON[WannabeDetailsKey.value.rawValue].object
        self.rounds = JSON[WannabeDetailsKey.rounds.rawValue].intValue
        self.wannabeId = JSON[WannabeDetailsKey.wannabeId.rawValue].stringValue
        self.timestamp = JSON[WannabeDetailsKey.timestamp.rawValue].intValue
    }
    
}
