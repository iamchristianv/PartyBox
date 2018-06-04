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

    var plays: Int = Partybox.values.zero

    var reviews: Int = Partybox.values.zero

    var rating: Int = Partybox.values.zero

    // MARK: - Construction Functions

    static func construct() -> WannabePackDetails {
        let details = WannabePackDetails()
        details.id = Partybox.values.none
        details.name = Partybox.values.none
        details.plays = Partybox.values.zero
        details.reviews = Partybox.values.zero
        details.rating = Partybox.values.zero
        return details
    }

    static func construct(json: JSON) -> WannabePackDetails {
        let details = WannabePackDetails()
        details.id = json[WannabePackDetailsKey.id.rawValue].stringValue
        details.name = json[WannabePackDetailsKey.name.rawValue].stringValue
        details.plays = json[WannabePackDetailsKey.plays.rawValue].intValue
        details.reviews = json[WannabePackDetailsKey.reviews.rawValue].intValue
        details.rating = json[WannabePackDetailsKey.rating.rawValue].intValue
        return details
    }

}
