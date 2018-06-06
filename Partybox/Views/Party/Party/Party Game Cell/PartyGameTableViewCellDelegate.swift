//
//  PartyGameTableViewCellDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 5/13/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Foundation

protocol PartyGameTableViewCellDelegate {

    func partyGameTableViewCell(_ cell: PartyGameTableViewCell, playButtonPressed: Bool)

    func partyGameTableViewCell(_ cell: PartyGameTableViewCell, changeButtonPressed: Bool)

}
