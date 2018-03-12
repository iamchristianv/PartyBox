//
//  User.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Shared Instance
    
    static var current: User = User()
    
    // MARK: - Instance Properties
    
    var name: String
    
    // MARK: - Initialization Functions
    
    init() {
        self.name = ""
    }
    
}
