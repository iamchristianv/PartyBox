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
    
    var name: String = ""
    
    var points: Int = 0
    
    var hints: Int = 5
    
    var isMember: Bool = false
    
    var hasAds: Bool = true
    
}
