//
//  Event.swift
//  Partybox
//
//  Created by Christian Villa on 7/14/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol Event: Identifiable, Nameable {

    // MARK: - Properties

    associatedtype PersonType where PersonType: Person

    var persons: OrderedSet<PersonType> { get set }

    var userId: String { get set }

    var timestamp: Int { get set }

    // MARK: - Functions

    func start(callback: @escaping (String?) -> Void)

    func end(callback: @escaping (String?) -> Void)

    func invite(name: String)

    func enter(callback: @escaping (String?) -> Void)

    func exit(callback: @escaping (String?) -> Void)

    func listen()

    func ignore()

}
