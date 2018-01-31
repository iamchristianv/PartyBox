//
//  WannabePack.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePack {
    
    // MARK: - Instance Properties
    
    var cards: [WannabeCard] = []
    
    // MARK: - Initialization Methods
    
    init(JSON: JSON) {
        for (_, cardJSON) in JSON {
            self.cards.append(WannabeCard(JSON: cardJSON))
        }
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [[String: Any]] {
        var JSON = [] as [[String: Any]]
        
        for card in self.cards {
            JSON.append(card.toJSON())
        }
        
        return JSON
    }
    
    // MARK: - Pack Methods
    
    func randomCard() -> WannabeCard {
        let randomIndex = Int(arc4random()) % self.cards.count
        let randomCard = self.cards[randomIndex]
        
        return randomCard
    }
    
}
