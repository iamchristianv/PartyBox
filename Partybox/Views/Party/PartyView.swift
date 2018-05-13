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

    private let staticTableViewCellCount: Int = 4
    
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.dataSource.partyViewUserName() != self.dataSource.partyViewPartyHost() {
            return []
        }
        
        let index = indexPath.row - self.staticTableViewCellCount
        
        guard let person = self.dataSource.partyViewPartyPerson(index: index) else {
            return []
        }
        
        if person.name == self.dataSource.partyViewPartyHost() {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staticTableViewCellCount + self.dataSource.partyViewPartyPeopleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let customCell = tableViewCell as! InviteCodeTableViewCell
            let inviteCode = self.dataSource.partyViewPartyId()
            customCell.configure(inviteCode: inviteCode)
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.configure(header: "GAME")
            return customCell
        }
        
        if indexPath.row == 2 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let customCell = tableViewCell as! GameTableViewCell
            let name = self.dataSource.partyViewPartyGameName()
            let summary = self.dataSource.partyViewPartyGameSummary()
            let isHostEnabled = self.dataSource.partyViewUserName() == self.dataSource.partyViewPartyHost()
            customCell.configure(name: name, summary: summary, isHostEnabled: isHostEnabled, delegate: self)
            self.playGameButton = customCell.playGameButton
            self.changeGameButton = customCell.changeGameButton
            return customCell
        }
        
        if indexPath.row == 3 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.configure(header: "PEOPLE")
            return customCell
        }
            
        if indexPath.row > 3 {
            let index = indexPath.row - self.staticTableViewCellCount
            
            guard let person = self.dataSource.partyViewPartyPerson(index: index) else {
                return UITableViewCell()
            }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
            let customCell = tableViewCell as! PersonTableViewCell
            let name = person.name
            let isMe = person.name == self.dataSource.partyViewUserName()
            let isHost = person.name == self.dataSource.partyViewPartyHost()
            let emoji = person.emoji
            let points = person.points
            customCell.configure(name: name, isMe: isMe, isHost: isHost, emoji: emoji, points: points)
            return customCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: GameTableViewCellDelegate {
    
    // MARK: - Game Table View Cell Delegate Functions

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playGameButtonPressed: Bool) {
        self.delegate.partyView(self, playButtonPressed: true)
    }

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeGameButtonPressed: Bool) {
        self.delegate.partyView(self, changeButtonPressed: true)
    }
    
}
