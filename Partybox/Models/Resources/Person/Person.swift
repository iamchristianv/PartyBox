//
//  Person.swift
//  Partybox
//
//  Created by Christian Villa on 7/14/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class Person: Identifiable {

    // MARK: - Remote Properties

    var name: String = Partybox.value.none

    var points: Int = Partybox.value.zero

}
