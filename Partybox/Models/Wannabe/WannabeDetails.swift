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
    
    // MARK: - Database Keys
    
    case isSetup
    
    case isReady
    
    case rounds
    
    case wannabeName
        
}

class WannabeDetails {    
    
    // MARK: - Instance Properties
    
    var id: String = "AS12"
    
    var name: String = "Wannabe"
    
    var summary: String = "Everyone knows what the secret is, except for one person: the wannabe! Find out who the wannabe is!"
    
    var instructions: String = "Wannabe Instructions"
    
    var isSetup: Bool = false
    
    var isReady: Bool = false
    
    var rounds: Int = 0
    
    var wannabeName: String = ""
    
    // MARK: - Database Properties
    
    var json: [String : Any] {
        let json = [
            WannabeDetailsKey.isSetup.rawValue: self.isSetup,
            WannabeDetailsKey.isReady.rawValue: self.isReady,
            WannabeDetailsKey.rounds.rawValue: self.rounds,
            WannabeDetailsKey.wannabeName.rawValue: self.wannabeName,
        ] as [String : Any]
        
        return json
    }
    
    var path: String {
        return "\(DatabaseKey.games.rawValue)/\(Party.details.id)/\(WannabeKey.details.rawValue)"
    }
    
    // MARK: - Initialization Functions
    
    init(JSON: JSON) {
        self.isSetup = JSON[WannabeDetailsKey.isSetup.rawValue].boolValue
        self.isReady = JSON[WannabeDetailsKey.isReady.rawValue].boolValue
        self.rounds = JSON[WannabeDetailsKey.rounds.rawValue].intValue
        self.wannabeName = JSON[WannabeDetailsKey.wannabeName.rawValue].stringValue
    }
    
}
