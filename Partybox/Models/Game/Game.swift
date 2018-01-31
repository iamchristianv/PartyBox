//
//  Game.swift
//  Partybox
//
//  Created by Christian Villa on 1/28/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Game {
    
    // MARK: - Instance Properties
    
    var details: GameDetails { get set }
    
    // MARK: - Initialization Functions
    
    init(JSON: JSON)
    
    // MARK: - JSON Functions
    
    func toJSON() -> [String: Any]
    
}
