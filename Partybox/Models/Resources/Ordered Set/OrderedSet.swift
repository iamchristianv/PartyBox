//
//  OrderedSet.swift
//  Partybox
//
//  Created by Christian Villa on 5/9/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

class OrderedSet<Object: Identifiable>: Sequence {

    // MARK: - Local Properties

    private var objects: [Object] = []

    private var indexes: [Object: Int] = [:]

    var count: Int {
        return self.objects.count
    }

    // MARK: - Ordered Set Functions

    func add(_ object: Object) {
        if let index = self.indexes[object] {
            self.objects[index] = object
        } else {
            self.objects.append(object)
            self.indexes[object] = self.objects.count - 1
        }
    }

    func remove(_ object: Object) {
        if let index = self.indexes[object] {
            self.objects.remove(at: index)
            self.indexes.removeValue(forKey: object)

            for i in index ..< self.objects.count {
                let obj = self.objects[i]
                self.indexes[obj] = i
            }
        }
    }

    subscript(index: Int) -> Object? {
        if index < 0 || index >= self.objects.count {
            return nil
        } else {
            return self.objects[index]
        }
    }

    subscript(id: String) -> Object? {
        for object in self.objects {
            if object.id == id {
                return object
            }
        }

        return nil
    }

    func random() -> Object? {
        if self.objects.count == 0 {
            return nil
        }

        let randomIndex = Int(arc4random()) % self.objects.count
        let randomObject = self.objects[randomIndex]

        return randomObject
    }

    // MARK: - Sequence Functions

    func makeIterator() -> Array<Object>.Iterator {
        return self.objects.makeIterator()
    }

}
