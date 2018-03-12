//
//  WannabePack.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabePackKey: String {
    
    // MARK: - Database Keys
    
    case id
    
    case name
    
    case cards
    
}

class WannabePack {
    
    // MARK: - Class Properties
    
    static var collection: [WannabePack] = []
    
    // MARK: - Instance Properties
    
    var id: String
    
    var name: String
    
    var cards: [WannabeCard]
    
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
    
    init() {
        self.id = ""
        self.name = ""
        self.cards = []
    }
    
    init(JSON: JSON) {
        self.id = JSON[WannabePackKey.id.rawValue].stringValue
        self.name = JSON[WannabePackKey.name.rawValue].stringValue
        self.cards = []

        for (_, cardJSON) in JSON[WannabePackKey.cards.rawValue] {
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
