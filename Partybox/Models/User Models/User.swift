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

    var name: String!

    // MARK: - Construction Functions

    static func construct(name: String) -> User {
        let user = User()
        return user
    }
    
}
