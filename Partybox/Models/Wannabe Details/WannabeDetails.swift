//
//  WannabeDetails.swift
//  Partybox
//
//  Created by Christian Villa on 12/9/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class WannabeDetails {
    
    // MARK: - Instance Properties
    
    var id: String = Partybox.defaults.none
    
    var name: String = Partybox.defaults.none

    var partyId: String = Partybox.defaults.none

    var summary: String = Partybox.defaults.none

    var instructions: String = Partybox.defaults.none
    
    var status: String = Partybox.defaults.none

    var rounds: Int = Partybox.defaults.zero

    var card: WannabeCard = WannabeCard()
    
    var wannabeName: String = Partybox.defaults.none

    private var dataSource: WannabeDetailsDataSource!

    // MARK: - Construction Functions

    static func construct(partyId: String, dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = "C2D4V"
        details.name = "Wannabe"
        details.partyId = partyId
        details.summary = "Wannabe Summary"
        details.instructions = "Wannabe Instructions"
        details.status = WannabeDetailsStatus.starting.rawValue
        details.rounds = WannabeDetailsRounds.three.rawValue
        details.card = WannabeCard.construct()
        details.wannabeName = Partybox.defaults.none
        details.dataSource = dataSource
        return details
    }

    static func construct(json: JSON, dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = json[WannabeDetailsKey.id.rawValue].stringValue
        details.name = json[WannabeDetailsKey.name.rawValue].stringValue
        details.partyId = json[WannabeDetailsKey.partyId.rawValue].stringValue
        details.summary = "Wannabe Summary"
        details.instructions = "Wannabe Instructions"
        details.status = json[WannabeDetailsKey.status.rawValue].stringValue
        details.rounds = json[WannabeDetailsKey.rounds.rawValue].intValue
        details.card = WannabeCard.construct(json: json[WannabeDetailsKey.card.rawValue])
        details.wannabeName = json[WannabeDetailsKey.wannabeName.rawValue].stringValue
        details.dataSource = dataSource
        return details
    }

    // MARK: - Database Functions

    func update(values: [String: Any], callback: @escaping (String?) -> Void) {
        let path = self.dataSource.wannabeDetailsPath()

        Database.database().reference().child(path).updateChildValues(values, withCompletionBlock: {
            (error, reference) in

            callback(error?.localizedDescription)
        })
    }

    // MARK: - Notification Functions

    func startObservingChanges() {
        let path = self.dataSource.wannabeDetailsPath()

        Database.database().reference().child(path).observe(.childChanged, with: {
            (snapshot) in

            if snapshot.key == WannabeDetailsKey.status.rawValue {
                self.status = snapshot.value as? String ?? self.status

                let name = Notification.Name(WannabeDetailsNotification.statusChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }

            if snapshot.key == WannabeDetailsKey.card.rawValue {
                guard let data = snapshot.value as? [String: Any] else {
                    return
                }

                let json = JSON(data)

                self.card = WannabeCard.construct(json: json)

                let name = Notification.Name(WannabeDetailsNotification.cardChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }
        })
    }

    func stopObservingChanges() {
        let path = self.dataSource.wannabeDetailsPath()

        Database.database().reference().child(path).removeAllObservers()
    }
    
}
