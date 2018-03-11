//
//  Alert.swift
//  Partybox
//
//  Created by Christian Villa on 3/11/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class Alert {
    
    // MARK: - Instance Properties
    
    var subject: String
    
    var message: String
    
    var action: String
    
    var handler: (() -> ())?
    
    // MARK: - Initialization Functions
    
    init(subject: String, message: String, action: String, handler: (() -> ())?) {
        self.subject = subject
        self.message = message
        self.action = action
        self.handler = handler
    }
    
}
