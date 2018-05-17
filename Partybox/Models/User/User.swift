//
//  User.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Instance Properties

    var name: String = Partybox.defaults.none

    // MARK: - Construction Functions

    static func construct(name: String) -> User {
        let user = User()
        user.name = name
        return user
    }
    
}
