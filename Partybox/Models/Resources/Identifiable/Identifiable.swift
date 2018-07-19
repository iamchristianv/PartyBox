//
//  Identifiable.swift
//  Partybox
//
//  Created by Christian Villa on 7/8/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol Identifiable: Hashable {

    // MARK: - Properties

    var id: String { get set }

}

extension Identifiable {

    // MARK: - Properties

    var hashValue: Int {
        return self.id.hashValue
    }

    // MARK: - Functions

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

}
