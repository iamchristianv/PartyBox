//
//  WannabeCollection.swift
//  Partybox
//
//  Created by Christian Villa on 5/10/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class WannabeCollection {

    // MARK: - Instance Properties

    var packs: OrderedSet<WannabePack> = OrderedSet<WannabePack>()

    private var dataSource: WannabeCollectionDataSource!

    private var packDataSource: WannabePackDataSource!

    // MARK: - Construction Functions

    static func construct(dataSource: WannabeCollectionDataSource, packDataSource: WannabePackDataSource) -> WannabeCollection {
        let collection = WannabeCollection()
        collection.packs = OrderedSet<WannabePack>()
        collection.dataSource = dataSource
        collection.packDataSource = packDataSource
        return collection
    }

    // MARK: - Collection Functions

    func fetchPacks(callback: @escaping (String?) -> Void) {
        let path = self.dataSource.wannabeCollectionPath()

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let json = JSON(data)

            for (_, value) in json {
                let pack = WannabePack.construct(json: value, dataSource: self.packDataSource)
                self.packs.add(pack)
            }

            callback(nil)
        })
    }

}
