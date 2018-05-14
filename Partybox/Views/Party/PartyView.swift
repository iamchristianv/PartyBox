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

    private var playGameButton: ActivityIndicatorButton?

    private var changeGameButton: ActivityIndicatorButton?
    
    private var delegate: PartyViewDelegate!

    private var dataSource: PartyViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: PartyViewDelegate, dataSource: PartyViewDataSource) -> PartyView {
        let view = PartyView()
        view.delegate = delegate
        view.dataSource = dataSource
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
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
    
    func startAnimatingPlayGameButton() {
        self.playGameButton?.startAnimating()
    }
    
    func stopAnimatingPlayGameButton() {
        self.playGameButton?.stopAnimating()
    }

    func startAnimatingChangeGameButton() {
        self.changeGameButton?.startAnimating()
    }

    func stopAnimatingChangeGameButton() {
        self.changeGameButton?.stopAnimating()
    }
    
}

extension PartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
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
            
            self.delegate.partyView(self, kickButtonPressed: person)
        })
        
        kickButton.backgroundColor = UIColor.Partybox.red
        
        return [kickButton]
    }
    
}

extension PartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
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
            gameHeaderCell.configure(header: "GAME")
            return gameHeaderCell
        }
        
        if indexPath.row == PartyViewCellRow.gameCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let gameCell = tableViewCell as! GameTableViewCell
            let name = self.dataSource.partyViewGameName()
            let summary = self.dataSource.partyViewGameSummary()
            let isHostEnabled = self.dataSource.partyViewUserName() == self.dataSource.partyViewHostName()
            gameCell.configure(name: name, summary: summary, isHostEnabled: isHostEnabled, delegate: self)
            self.playGameButton = gameCell.playGameButton
            self.changeGameButton = gameCell.changeGameButton
            return gameCell
        }
        
        if indexPath.row == PartyViewCellRow.peopleHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let peopleHeaderCell = tableViewCell as! HeaderTableViewCell
            peopleHeaderCell.configure(header: "PEOPLE")
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
    
    // MARK: - Game Table View Cell Delegate Functions

    internal func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playGameButtonPressed: Bool) {
        self.delegate.partyView(self, playGameButtonPressed: true)
    }

    internal func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeGameButtonPressed: Bool) {
        self.delegate.partyView(self, changeGameButtonPressed: true)
    }
    
}
