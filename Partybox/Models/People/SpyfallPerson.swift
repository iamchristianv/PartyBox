//
//  SpyfallPerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SpyfallPersonKey: String {
    
    case name
    
    case spy
    
    case vote
    
}

class SpyfallPerson {
    
    // MARK: - Instance Properties
    
    var name: String
    
    var spy: Bool
    
    var vote: String
    
    // MARK: - Initialization Methods
    
    init(name: String, spy: Bool) {
        self.name = name
        self.spy = spy
        self.vote = ""
    }
    
    required init(name: String, JSON: JSON) {
        self.name = name
        self.spy = JSON[SpyfallPersonKey.spy.rawValue].boolValue
        self.vote = JSON[SpyfallPersonKey.vote.rawValue].stringValue
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String : Any] {
        let JSON = [
            self.name: [
                SpyfallPersonKey.spy.rawValue: self.spy,
                SpyfallPersonKey.vote.rawValue: self.vote
            ]
        ] 
        
        return JSON
    }
    
}
