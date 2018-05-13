//
//  PartyDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class PartyDetails {
    
    // MARK: - Instance Properties
    
    var id: String = Partybox.none
    
    var name: String = Partybox.none

    var game: String = Partybox.none

    var host: String = Partybox.none

    var time: Int = Partybox.zero

    private var dataSource: PartyDetailsDataSource!

    // MARK: - Construction Functions

    static func construct(name: String, dataSource: PartyDetailsDataSource) -> PartyDetails {
        let details = PartyDetails()
        details.id = Partybox.randomPartyId()
        details.name = name
        details.game = Partybox.randomGameId()
        details.host = Partybox.none
        details.time = Partybox.zero
        details.dataSource = dataSource
        return details
    }

    static func construct(id: String, dataSource: PartyDetailsDataSource) -> PartyDetails {
        let details = PartyDetails()
        details.id = id
        details.name = Partybox.none
        details.game = Partybox.randomGameId()
        details.host = Partybox.none
        details.time = Partybox.zero
        details.dataSource = dataSource
        return details
    }

    static func construct(json: JSON, dataSource: PartyDetailsDataSource) -> PartyDetails {
        let details = PartyDetails()
        details.id = json[PartyDetailsKey.id.rawValue].stringValue
        details.name = json[PartyDetailsKey.name.rawValue].stringValue
        details.game = json[PartyDetailsKey.game.rawValue].stringValue
        details.host = json[PartyDetailsKey.host.rawValue].stringValue
        details.time = json[PartyDetailsKey.time.rawValue].intValue
        details.dataSource = dataSource
        return details
    }

    // MARK: - Database Functions

    func update(values: [String: Any], callback: @escaping (String?) -> Void) {
        let path = self.dataSource.partyDetailsPath()

        Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    func startObservingChanges() {
        let path = self.dataSource.partyDetailsPath()

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            if snapshot.key == PartyDetailsKey.name.rawValue {
                self.name = snapshot.value as? String ?? self.name

                let name = Notification.Name(PartyDetailsNotification.nameChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }

            if snapshot.key == PartyDetailsKey.game.rawValue {
                self.game = snapshot.value as? String ?? self.game

                let name = Notification.Name(PartyDetailsNotification.gameChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }

            if snapshot.key == PartyDetailsKey.host.rawValue {
                self.host = snapshot.value as? String ?? self.host

                let name = Notification.Name(PartyDetailsNotification.hostChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }
        })
    }

    func stopObservingChanges() {
        let path = self.dataSource.partyDetailsPath()

        Database.database().reference().child(path).removeAllObservers()
    }
    
}
