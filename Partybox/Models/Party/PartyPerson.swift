//
//  PartyPerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PartyPersonKey: String {
    
    // MARK: - Property Keys

    case id
    
    case name

    case status

    case value
    
    case points
    
}

enum PartyPersonStatus: String {

    // MARK: - Status Types

    case waiting = "Waiting"

}

class PartyPerson {

    // MARK: - Instance Properties

    var id: String
    
    var name: String

    var status: String

    var value: Any?
    
    var points: Int
    
    // MARK: - Initialization Functions
    
    init() {
        self.id = ""
        self.name = ""
        self.status = PartyPersonStatus.waiting.rawValue
        self.value = nil
        self.points = 0
    }
    
    init(JSON: JSON) {
        self.id = JSON[PartyPersonKey.id.rawValue].stringValue
        self.name = JSON[PartyPersonKey.name.rawValue].stringValue
        self.status = JSON[PartyPersonKey.status.rawValue].stringValue
        self.value = JSON[PartyPersonKey.value.rawValue].object
        self.points = JSON[PartyPersonKey.points.rawValue].intValue
    }
    
}
