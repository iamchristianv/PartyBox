//
//  GameTableViewCellDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol GameTableViewCellDelegate {

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playButtonPressed: Bool)

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeButtonPressed: Bool)

}
