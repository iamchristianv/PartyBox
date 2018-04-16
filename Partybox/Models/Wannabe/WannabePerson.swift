//
//  WannabePerson.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WannabePersonKey: String {
    
    // MARK: - Property Keys

    case id
    
    case name

    case status

    case value
    
    case points

}

enum WannabePersonStatus: String {

    // MARK: - Status Types

    case waiting = "Waiting"

}

class WannabePerson {
    
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
        self.status = WannabePersonStatus.waiting.rawValue
        self.value = nil
        self.points = 0
    }
    
    init(JSON: JSON) {
        self.id = JSON[WannabePersonKey.id.rawValue].stringValue
        self.name = JSON[WannabePersonKey.name.rawValue].stringValue
        self.status = JSON[WannabePersonKey.status.rawValue].stringValue
        self.value = JSON[WannabePersonKey.value.rawValue].object
        self.points = JSON[WannabePersonKey.points.rawValue].intValue
    }
    
}
