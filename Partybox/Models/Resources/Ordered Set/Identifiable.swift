//
//  Identifiable.swift
//  Partybox
//
//  Created by Christian Villa on 7/8/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol Identifiable: Hashable {

    var id: String { get set }

}
