//
//  GameTableViewCellDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol GameTableViewCellDelegate {

    // MARK: - Game Table View Cell Functions

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playGameButtonPressed: Bool)

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeGameButtonPressed: Bool)

}
