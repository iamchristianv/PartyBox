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
    
    var count: Int {
        return self.cards.count
    }
    
    // MARK: - JSON Properties
    
    var json: [[String: Any]] {
        var json = [] as [[String: Any]]
        
        for card in self.cards {
            json.append(card.json)
        }
        
        return json
    }
    
    // MARK: - Initialization Functions
    
    init(JSON: JSON) {
        for (_, cardJSON) in JSON {
            self.add(WannabeCard(JSON: cardJSON))
        }
    }
    
    // MARK: - Pack Functions
    
    func add(_ card: WannabeCard) {
        self.cards.append(card)
    }
    
    // MARK: - Utility Functions
    
    func randomCard() -> WannabeCard {
        let randomIndex = Int(arc4random()) % self.cards.count
        let randomCard = self.cards[randomIndex]
        
        return randomCard
    }
    
}
