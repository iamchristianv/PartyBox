//
//  Spyfall.swift
//  Partybox
//
//  Created by Christian Villa on 11/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SpyfallKey: String {
    
    case details
    
    case pack
            
    case people
    
}

class Spyfall {
    
    // MARK: - Instance Properties
    
    var details: SpyfallDetails
    
    var pack: SpyfallPack
    
    var people: SpyfallPeople
    
    // MARK: - Initialization Methods
    
    init(details: SpyfallDetails, pack: SpyfallPack, people: SpyfallPeople) {
        self.details = details
        self.pack = pack
        self.people = people
    }
    
    init(JSON: JSON) {
        self.details = SpyfallDetails(JSON: JSON[SpyfallKey.details.rawValue])
        self.pack = SpyfallPack(JSON: JSON[SpyfallKey.pack.rawValue])
        self.people = SpyfallPeople(JSON: JSON[SpyfallKey.people.rawValue])
    }
    
    // MARK: - JSON Methods
    
    func toJSON() -> [String: Any] {
        let JSON = [
            SpyfallKey.details.rawValue: self.details.toJSON(),
            SpyfallKey.pack.rawValue: self.pack.toJSON(),
            SpyfallKey.people.rawValue: self.people.toJSON()
        ] as [String: Any]
        
        return JSON
    }
    
}
