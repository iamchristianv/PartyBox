//
//  WannabePackDetails.swift
//  Partybox
//
//  Created by Christian Villa on 6/3/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WannabePackDetails {

    // MARK: - Instance Properties

    var id: String = Partybox.values.none

    var name: String = Partybox.values.none

    // MARK: - Construction Functions

    static func construct() -> WannabePackDetails {
        let details = WannabePackDetails()
        details.id = Partybox.values.none
        details.name = Partybox.values.none
        return details
    }

    static func construct(json: JSON) -> WannabePackDetails {
        let details = WannabePackDetails()
        details.id = json[WannabePackDetailsKey.id.rawValue].stringValue
        details.name = json[WannabePackDetailsKey.name.rawValue].stringValue
        return details
    }

}
