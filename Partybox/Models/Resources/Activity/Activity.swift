//
//  Activity.swift
//  Partybox
//
//  Created by Christian Villa on 7/18/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Activity: Event, Summarizable {

    // MARK: - Properties

    associatedtype CardType where CardType: Card

    var cards: OrderedSet<CardType> { get set }

    var partyId: String { get set }

    var instructions: String { get set }

}
