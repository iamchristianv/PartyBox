//
//  PartyGame.swift
//  Partybox
//
//  Created by Christian Villa on 12/20/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyGameCode: String {
    
    case spyfall = "CV24"
    
    case wannabe = "AS12"
    
}

enum PartyGameKey: String {
    
    case details
    
    case pack
    
    case people
    
}

protocol PartyGame {
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON)
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any]
    
}
