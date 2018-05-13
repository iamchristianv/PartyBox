//
//  OrderedSet.swift
//  Partybox
//
//  Created by Christian Villa on 5/9/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class OrderedSet<T: Hashable> {

    // MARK: - Initialization Functions

    var objects: [T] = []

    var objectsToIndexes: [T: Int] = [:]

    var count: Int {
        return self.objects.count
    }

    // MARK: - Ordered Set Functions

    func add(_ object: T) {
        if let index = self.objectsToIndexes[object] {
            self.objects[index] = object
        } else {
            self.objects.append(object)
            self.objectsToIndexes[object] = self.objects.count - 1
        }
    }

    func remove(_ object: T) {
        if let index = self.objectsToIndexes[object] {
            self.objects.remove(at: index)
            self.objectsToIndexes.removeValue(forKey: object)

            for i in index ..< self.objects.count {
                let t = self.objects[i]
                self.objectsToIndexes[t] = i
            }
        }
    }

    func fetch(index: Int) -> T? {
        if index < 0 || index >= self.objects.count {
            return nil
        } else {
            return self.objects[index]
        }
    }

    func contains(_ object: T) -> Bool {
        if self.objectsToIndexes[object] != nil {
            return true
        } else {
            return false
        }
    }

    func random() -> T? {
        if self.objects.count == 0 {
            return nil
        }

        let randomIndex = Int(arc4random()) % self.objects.count
        let randomObject = self.objects[randomIndex]

        return randomObject
    }

}
