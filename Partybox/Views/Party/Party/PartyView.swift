//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyView: UIView {

    // MARK: - Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(InviteCodeTableViewCell.self, forCellReuseIdentifier: InviteCodeTableViewCell.identifier)
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.identifier)
        tableView.register(PartyGameTableViewCell.self, forCellReuseIdentifier: PartyGameTableViewCell.identifier)
        tableView.register(PartyGuestTableViewCell.self, forCellReuseIdentifier: PartyGuestTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()

    private var playButton: ActivityIndicatorButton?
    
    private var delegate: PartyViewDelegate

    private var dataSource: PartyViewDataSource

    // MARK: - Initialization Functions

    init(delegate: PartyViewDelegate, dataSource: PartyViewDataSource) {
        self.playButton = nil
        self.delegate = delegate
        self.dataSource = dataSource
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.tableView)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
    }

    // MARK: - Animation Functions

    func startAnimatingPlayButton() {
        self.playButton?.startAnimating()
    }

    func stopAnimatingPlayButton() {
        self.playButton?.stopAnimating()
    }
    
    // MARK: - View Functions

    func reloadTable() {
        self.tableView.reloadData()
    }

    // MARK: - Utility Functions

    private static func randomPersonEmoji() -> String {
        let emojis = ["😊"]

        let randomIndex = Int(arc4random()) % emojis.count
        let randomEmoji = emojis[randomIndex]

        return randomEmoji
    }
    
}

extension PartyView: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.dataSource.partyViewPartyUserId() != self.dataSource.partyViewPartyHostId() {
            return []
        }
        
        let index = indexPath.row - PartyViewCellRow.partyGuestCells.rawValue

        if self.dataSource.partyViewPartyPersonId(index: index) == self.dataSource.partyViewPartyHostId() {
            return []
        }
        
        let kickButton = UITableViewRowAction(style: .normal, title: "KICK", handler: {
            (rowAction, indexPath) in
            
            self.delegate.partyView(self, personKicked: self.dataSource.partyViewPartyPersonId(index: index))
        })
        
        kickButton.backgroundColor = Partybox.color.red
        
        return [kickButton]
    }
    
}

extension PartyView: UITableViewDataSource {

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartyViewCellRow.partyGuestCells.rawValue + self.dataSource.partyViewPartyPersonsCount()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == PartyViewCellRow.inviteCodeCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let inviteCodeCell = tableViewCell as! InviteCodeTableViewCell
            let inviteCode = self.dataSource.partyViewPartyId()
            inviteCodeCell.configure(inviteCode: inviteCode)
            return inviteCodeCell
        }

        if indexPath.row == PartyViewCellRow.partyGameHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyGameHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GAME"
            partyGameHeaderCell.configure(header: header)
            return partyGameHeaderCell
        }

        if indexPath.row == PartyViewCellRow.partyGameCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PartyGameTableViewCell.identifier)
            let partyGameCell = tableViewCell as! PartyGameTableViewCell
            let name = self.dataSource.partyViewGameName()
            let summary = self.dataSource.partyViewGameSummary()
            let hasHostActions = self.dataSource.partyViewPartyUserId() == self.dataSource.partyViewPartyHostId()
            partyGameCell.configure(name: name, summary: summary, hasHostActions: hasHostActions, delegate: self)
            self.playButton = partyGameCell.playButton
            return partyGameCell
        }

        if indexPath.row == PartyViewCellRow.partyGuestsHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyGuestsHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GUESTS"
            partyGuestsHeaderCell.configure(header: header)
            return partyGuestsHeaderCell
        }

        if indexPath.row >= PartyViewCellRow.partyGuestCells.rawValue {
            let index = indexPath.row - PartyViewCellRow.partyGuestCells.rawValue

            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PartyGuestTableViewCell.identifier)
            let partyGuestCell = tableViewCell as! PartyGuestTableViewCell
            let name = self.dataSource.partyViewPartyPersonName(index: index)
            let isMe = self.dataSource.partyViewPartyPersonId(index: index) == self.dataSource.partyViewPartyUserId()
            let isHost = self.dataSource.partyViewPartyPersonId(index: index) == self.dataSource.partyViewPartyHostId()
            let emoji = PartyView.randomPersonEmoji()
            let points = self.dataSource.partyViewPartyPersonPoints(index: index)
            partyGuestCell.configure(name: name, isMe: isMe, isHost: isHost, emoji: emoji, points: points)
            return partyGuestCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: PartyGameTableViewCellDelegate {
    
    internal func partyGameTableViewCell(_ cell: PartyGameTableViewCell, playButtonPressed: Bool) {
        self.delegate.partyView(self, playButtonPressed: true)
    }

    internal func partyGameTableViewCell(_ cell: PartyGameTableViewCell, changeButtonPressed: Bool) {
        self.delegate.partyView(self, changeButtonPressed: true)
    }
    
}
