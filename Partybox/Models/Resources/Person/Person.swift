//
//  Person.swift
//  Partybox
//
//  Created by Christian Villa on 7/14/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol Person: Identifiable, Nameable {

    // MARK: - Properties

    var points: Int { get set }

}
