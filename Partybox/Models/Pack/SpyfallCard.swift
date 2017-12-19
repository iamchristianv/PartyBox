//
//  SpyfallCard.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SpyfallCardKey: String {
    
    case content
    
}

class SpyfallCard {
    
    // MARK: - Instance Properties
    
    var content: String
    
    // MARK: - Initialization Methods
    
    init(content: String) {
        self.content = content
    }
    
}
