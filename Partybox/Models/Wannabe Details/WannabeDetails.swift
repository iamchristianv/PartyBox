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
    
    var id: String = Partybox.none
    
    var name: String = Partybox.none

    var party: String = Partybox.none

    var summary: String = Partybox.none

    var instructions: String = Partybox.none
    
    var status: String = Partybox.none

    var rounds: Int = Partybox.zero

    var card: WannabeCard = WannabeCard()
    
    var wannabe: String = Partybox.none

    private var dataSource: WannabeDetailsDataSource!

    // MARK: - Construction Functions

    static func construct(party: String, dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = "C2D4V"
        details.name = "Wannabe"
        details.party = party
        details.summary = "Wannabe Summary"
        details.instructions = "Wannabe Instructions"
        details.status = WannabeDetailsStatus.starting.rawValue
        details.rounds = WannabeDetailsRounds.three.rawValue
        details.card = WannabeCard.construct()
        details.wannabe = Partybox.none
        details.dataSource = dataSource
        return details
    }

    static func construct(json: JSON, dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = json[WannabeDetailsKey.id.rawValue].stringValue
        details.name = json[WannabeDetailsKey.name.rawValue].stringValue
        details.party = json[WannabeDetailsKey.party.rawValue].stringValue
        details.summary = "Wannabe Summary"
        details.instructions = "Wannabe Instructions"
        details.status = json[WannabeDetailsKey.status.rawValue].stringValue
        details.rounds = json[WannabeDetailsKey.rounds.rawValue].intValue
        details.card = WannabeCard.construct(json: json[WannabeDetailsKey.card.rawValue])
        details.wannabe = json[WannabeDetailsKey.wannabe.rawValue].stringValue
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
