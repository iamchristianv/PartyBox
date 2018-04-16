//
//  Countdown.swift
//  Partybox
//
//  Created by Christian Villa on 3/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

enum CountdownNotification: String {
    
    // MARK: - Notification Types
    
    case timeStarted = "Countdown/timeStarted"
    
    case timeChanged = "Countdown/timeChanged"
    
    case timeEnded = "Countdown/timeEnded"
    
}

class Countdown {
    
    // MARK: - Shared Instance
    
    static var current: Countdown = Countdown()
    
    // MARK: - Instance Properties
    
    var timer: Timer
    
    var seconds: Int
    
    // MARK: - Initialization Functions
    
    init() {
        self.timer = Timer()
        self.seconds = 0
    }
    
    // MARK: - Timer Functions
    
    func start(seconds: Int) {
        self.seconds = seconds
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(change), userInfo: nil, repeats: true)
        
        let name = Notification.Name(CountdownNotification.timeStarted.rawValue)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    @objc func change() {
        self.seconds -= 1
        
        let name = Notification.Name(CountdownNotification.timeChanged.rawValue)
        NotificationCenter.default.post(name: name, object: nil)
        
        if self.seconds == 0 {
            self.end()
        }
    }
    
    func end() {
        self.timer.invalidate()
        
        let name = Notification.Name(CountdownNotification.timeEnded.rawValue)
        NotificationCenter.default.post(name: name, object: nil)
        
        self.seconds = 0
    }
    
}
