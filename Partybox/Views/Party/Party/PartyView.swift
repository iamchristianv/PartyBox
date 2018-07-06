//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyView: UIView {

    // MARK: - Instance Properties

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
        tableView.register(PartyPersonTableViewCell.self, forCellReuseIdentifier: PartyPersonTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()

    private var playButton: ActivityIndicatorButton?
    
    private var delegate: PartyViewDelegate!

    private var dataSource: PartyViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: PartyViewDelegate, dataSource: PartyViewDataSource) -> PartyView {
        let view = PartyView()
        view.playButton = nil
        view.delegate = delegate
        view.dataSource = dataSource
        view.setupView()
        return view
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
        if self.dataSource.partyViewUserName() != self.dataSource.partyViewPartyHostName() {
            return []
        }
        
        let index = indexPath.row - PartyViewCellRow.partyPersonCells.rawValue
        
        guard let person = self.dataSource.partyViewPartyPerson(index: index) else {
            return []
        }
        
        if person.name == self.dataSource.partyViewPartyHostName() {
            return []
        }
        
        let kickButton = UITableViewRowAction(style: .normal, title: "KICK", handler: {
            (rowAction, indexPath) in
            
            self.delegate.partyView(self, partyPersonKicked: person.name)
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
        return PartyViewCellRow.partyPersonCells.rawValue + self.dataSource.partyViewPartyPeopleCount()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == PartyViewCellRow.inviteCodeCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let inviteCodeCell = tableViewCell as! InviteCodeTableViewCell
            let inviteCode = self.dataSource.partyViewPartyId()
            inviteCodeCell.configure(inviteCode: inviteCode)
            return inviteCodeCell
        } else if indexPath.row == PartyViewCellRow.partyGameHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyGameHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GAME"
            partyGameHeaderCell.configure(header: header)
            return partyGameHeaderCell
        } else if indexPath.row == PartyViewCellRow.partyGameCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PartyGameTableViewCell.identifier)
            let partyGameCell = tableViewCell as! PartyGameTableViewCell
            let name = self.dataSource.partyViewPartyGameName()
            let summary = self.dataSource.partyViewPartyGameSummary()
            let hasHostActions = self.dataSource.partyViewUserName() == self.dataSource.partyViewPartyHostName()
            partyGameCell.configure(name: name, summary: summary, hasHostActions: hasHostActions, delegate: self)
            self.playButton = partyGameCell.playButton
            return partyGameCell
        } else if indexPath.row == PartyViewCellRow.partyPeopleHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyPeopleHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "PEOPLE"
            partyPeopleHeaderCell.configure(header: header)
            return partyPeopleHeaderCell
        } else if indexPath.row >= PartyViewCellRow.partyPersonCells.rawValue {
            let index = indexPath.row - PartyViewCellRow.partyPersonCells.rawValue
            
            guard let person = self.dataSource.partyViewPartyPerson(index: index) else {
                return UITableViewCell()
            }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PartyPersonTableViewCell.identifier)
            let partyPersonCell = tableViewCell as! PartyPersonTableViewCell
            let name = person.name
            let isMe = person.name == self.dataSource.partyViewUserName()
            let isHost = person.name == self.dataSource.partyViewPartyHostName()
            let emoji = person.emoji
            let points = person.points
            partyPersonCell.configure(name: name, isMe: isMe, isHost: isHost, emoji: emoji, points: points)
            return partyPersonCell
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
