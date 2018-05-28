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
    
    var id: String = Partybox.values.none
    
    var name: String = Partybox.values.none

    var status: String = Partybox.values.none

    var maxRounds: Int = Partybox.values.zero

    var activeCard: WannabeCard = WannabeCard()
    
    var wannabeName: String = Partybox.values.none

    private var dataSource: WannabeDetailsDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = "C2D4V"
        details.name = "Wannabe"
        details.status = WannabeDetailsStatus.starting.rawValue
        details.maxRounds = WannabeDetailsRounds.three.rawValue
        details.activeCard = WannabeCard.construct()
        details.wannabeName = Partybox.values.none
        details.dataSource = dataSource
        return details
    }

    static func construct(json: JSON, dataSource: WannabeDetailsDataSource) -> WannabeDetails {
        let details = WannabeDetails()
        details.id = json[WannabeDetailsKey.id.rawValue].stringValue
        details.name = json[WannabeDetailsKey.name.rawValue].stringValue
        details.status = json[WannabeDetailsKey.status.rawValue].stringValue
        details.maxRounds = json[WannabeDetailsKey.maxRounds.rawValue].intValue
        details.activeCard = WannabeCard.construct(json: json[WannabeDetailsKey.activeCard.rawValue])
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

            if snapshot.key == WannabeDetailsKey.activeCard.rawValue {
                guard let data = snapshot.value as? [String: Any] else {
                    return
                }

                let json = JSON(data)

                self.activeCard = WannabeCard.construct(json: json)

                let name = Notification.Name(WannabeDetailsNotification.activeCardChanged.rawValue)
                NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
            }
        })
    }

    func stopObservingChanges() {
        let path = self.dataSource.wannabeDetailsPath()

        Database.database().reference().child(path).removeAllObservers()
    }
    
}
