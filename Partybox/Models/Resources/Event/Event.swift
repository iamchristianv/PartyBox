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

    func initialize(callback: @escaping (String?) -> Void)

    func terminate(callback: @escaping (String?) -> Void)

    func createPerson(name: String) -> PersonType

    func insert(person: PersonType, callback: @escaping (String?) -> Void)

    func remove(person: PersonType, callback: @escaping (String?) -> Void)

    func startObservingChanges()

    func stopObservingChanges()

}
