//
//  SpyfallPack.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SpyfallPackKey: String {
    
    case cards
    
    case selected
    
}

class SpyfallPack {
    
    // MARK: - Instance Properties
    
    var cards: [SpyfallCard]
    
    var selected: SpyfallCard
    
    // MARK: - Initialization Methods
    
    init() {
        self.cards = []
        self.selected = SpyfallCard(content: "")
    }
    
    init(JSON: JSON) {
        self.cards = []
        
        for (_, value) in JSON[SpyfallPackKey.cards.rawValue] {
            self.cards.append(SpyfallCard(content: value.stringValue))
        }
        
        self.selected = SpyfallCard(content: JSON[SpyfallPackKey.selected.rawValue].stringValue)
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        var values = [] as [String]
        
        for card in self.cards {
            values.append(card.content)
        }
        
        let JSON = [
            SpyfallPackKey.cards.rawValue: values,
            SpyfallPackKey.selected.rawValue: self.selected.content
        ] as [String: Any]
        
        return JSON
    }
    
    // MARK: - Pack Methods
    
    func selectRandomCard() {
        let randomIndex = Int(arc4random()) % self.cards.count
        let randomCard = self.cards[randomIndex]
        
        self.selected = randomCard
    }
    
}
