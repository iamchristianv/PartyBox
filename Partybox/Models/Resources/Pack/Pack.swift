//
//  Pack.swift
//  Partybox
//
//  Created by Christian Villa on 7/15/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol Pack: Identifiable, Nameable, Summarizable {

    // MARK: - Properties

    associatedtype CardType where CardType: Card

    var cards: OrderedSet<CardType> { get set }

}
