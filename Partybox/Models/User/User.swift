//
//  User.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum UserKey: String {

    // MARK: - Property Keys

    case name

}

class User {
    
    // MARK: - Instance Properties
    
    var name: String

    // MARK: - Initialization Functions

    init() {
        self.name = ""
    }
    
}
