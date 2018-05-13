//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PartyViewDelegate {
    
    // MARK: - Party View Delegate Functions
    
    func partyView(_ partyView: PartyView, playButtonPressed: Bool)
    
    func partyView(_ partyView: PartyView, changeButtonPressed: Bool)
    
    func partyView(_ partyView: PartyView, kickButtonPressed person: PartyPerson)

}

protocol PartyViewDataSource {

    // MARK: - Party View Data Source Functions

    func partyViewUserName() -> String

    func partyViewPartyHost() -> String

    func partyViewPartyPerson(index: Int) -> PartyPerson?

    func partyViewPartyPeopleCount() -> Int

    func partyViewPartyId() -> String

    func partyViewPartyGameName() -> String

    func partyViewPartyGameSummary() -> String

}

class PartyView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 4

    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
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
    
    var delegate: PartyViewDelegate!

    var dataSource: PartyViewDataSource!

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
    
    func startAnimatingPlayButton() {
        
    }
    
    func stopAnimatingPlayButton() {
        
    }
    
}

extension PartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.dataSource.partyViewUserName() != self.dataSource.partyViewPartyHost() {
            return []
        }
        
        let index = indexPath.row - PartyView.staticTableViewCellCount
        
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
        return PartyView.staticTableViewCellCount + self.dataSource.partyViewPartyPeopleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let customCell = tableViewCell as! InviteCodeTableViewCell
            customCell.setInviteCode(self.dataSource.partyViewPartyId())
            customCell.setupView()
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setHeader("GAME")
            customCell.setupView()
            return customCell
        }
        
        if indexPath.row == 2 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let customCell = tableViewCell as! GameTableViewCell
            customCell.delegate = self
            customCell.setName(self.dataSource.partyViewPartyGameName())
            customCell.setSummary(self.dataSource.partyViewPartyGameSummary())
            customCell.setIsEnabledForHost(self.dataSource.partyViewUserName() == self.dataSource.partyViewPartyHost())
            customCell.setupView()

            return customCell
        }
        
        if indexPath.row == 3 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setHeader("PEOPLE")
            customCell.setupView()
            return customCell
        }
            
        if indexPath.row > 3 {
            let index = indexPath.row - PartyView.staticTableViewCellCount
            
            guard let person = self.dataSource.partyViewPartyPerson(index: index) else {
                return UITableViewCell()
            }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
            let customCell = tableViewCell as! PersonTableViewCell
            customCell.setName(person.name)
            customCell.setFlair(isMe: person.name == self.dataSource.partyViewUserName(),
                                isHost: person.name == self.dataSource.partyViewPartyHost())
            customCell.setEmoji(person.emoji)
            customCell.setPoints(person.points)
            customCell.setupView()
            return customCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: GameTableViewCellDelegate {
    
    // MARK: - Game Table View Cell Delegate Functions

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playButtonPressed: Bool) {
        self.delegate.partyView(self, playButtonPressed: true)
    }

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeButtonPressed: Bool) {
        self.delegate.partyView(self, changeButtonPressed: true)
    }
    
}
