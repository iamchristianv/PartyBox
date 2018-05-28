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
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()

    private var playButton: ActivityIndicatorButton?

    private var changeButton: ActivityIndicatorButton?
    
    private var delegate: PartyViewDelegate!

    private var dataSource: PartyViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: PartyViewDelegate, dataSource: PartyViewDataSource) -> PartyView {
        let view = PartyView()
        view.playButton = nil
        view.changeButton = nil
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
    
    // MARK: - View Functions

    func reloadTable() {
        self.tableView.reloadData()
    }
    
    // MARK: - Animation Functions
    
    func startAnimatingPlayButton() {
        self.playButton?.startAnimating()
    }
    
    func stopAnimatingPlayButton() {
        self.playButton?.stopAnimating()
    }

    func startAnimatingChangeButton() {
        self.changeButton?.startAnimating()
    }

    func stopAnimatingChangeButton() {
        self.changeButton?.stopAnimating()
    }
    
}

extension PartyView: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.dataSource.partyViewUserName() != self.dataSource.partyViewHostName() {
            return []
        }
        
        let index = indexPath.row - PartyViewCellRow.personCells.rawValue
        
        guard let person = self.dataSource.partyViewPerson(index: index) else {
            return []
        }
        
        if person.name == self.dataSource.partyViewHostName() {
            return []
        }
        
        let kickButton = UITableViewRowAction(style: .normal, title: "KICK", handler: {
            (rowAction, indexPath) in
            
            self.delegate.partyView(self, kickButtonPressed: person.name)
        })
        
        kickButton.backgroundColor = Partybox.colors.red
        
        return [kickButton]
    }
    
}

extension PartyView: UITableViewDataSource {

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartyViewCellRow.personCells.rawValue + self.dataSource.partyViewPeopleCount()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == PartyViewCellRow.inviteCodeCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let inviteCodeCell = tableViewCell as! InviteCodeTableViewCell
            let inviteCode = self.dataSource.partyViewPartyId()
            inviteCodeCell.configure(inviteCode: inviteCode)
            return inviteCodeCell
        }
        
        if indexPath.row == PartyViewCellRow.gameHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let gameHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GAME"
            gameHeaderCell.configure(header: header)
            return gameHeaderCell
        }
        
        if indexPath.row == PartyViewCellRow.gameCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let gameCell = tableViewCell as! GameTableViewCell
            let name = self.dataSource.partyViewGameName()
            let summary = self.dataSource.partyViewGameSummary()
            let isHostEnabled = self.dataSource.partyViewUserName() == self.dataSource.partyViewHostName()
            gameCell.configure(name: name, summary: summary, isHostEnabled: isHostEnabled, delegate: self)
            self.playButton = gameCell.playButton
            self.changeButton = gameCell.changeButton
            return gameCell
        }
        
        if indexPath.row == PartyViewCellRow.peopleHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let peopleHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "PEOPLE"
            peopleHeaderCell.configure(header: header)
            return peopleHeaderCell
        }
            
        if indexPath.row >= PartyViewCellRow.personCells.rawValue {
            let index = indexPath.row - PartyViewCellRow.personCells.rawValue
            
            guard let person = self.dataSource.partyViewPerson(index: index) else {
                return UITableViewCell()
            }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
            let personCell = tableViewCell as! PersonTableViewCell
            let name = person.name
            let isMe = person.name == self.dataSource.partyViewUserName()
            let isHost = person.name == self.dataSource.partyViewHostName()
            let emoji = person.emoji
            let points = person.points
            personCell.configure(name: name, isMe: isMe, isHost: isHost, emoji: emoji, points: points)
            return personCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: GameTableViewCellDelegate {
    
    internal func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playButtonPressed: Bool) {
        self.delegate.partyView(self, playButtonPressed: true)
    }

    internal func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeButtonPressed: Bool) {
        self.delegate.partyView(self, changeButtonPressed: true)
    }
    
}
