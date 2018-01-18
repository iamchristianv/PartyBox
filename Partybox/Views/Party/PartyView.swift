//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PartyViewDelegate {
    
    func partyView(_ partyView: PartyView, startGameButtonPressed startGameButton: UIButton)
    
    func partyView(_ partyView: PartyView, changeGameButtonPressed startGameButton: UIButton)

}

class PartyView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 5

    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(InviteCodeTableViewCell.self, forCellReuseIdentifier: InviteCodeTableViewCell.identifier)
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.identifier)
        tableView.register(WaitingTableViewCell.self, forCellReuseIdentifier: WaitingTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(DoubleButtonTableViewCell.self, forCellReuseIdentifier: DoubleButtonTableViewCell.identifier)
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.register(GameInstructionsTableViewCell.self, forCellReuseIdentifier: GameInstructionsTableViewCell.identifier)
        tableView.register(GameCountdownTableViewCell.self, forCellReuseIdentifier: GameCountdownTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var delegate: PartyViewDelegate!
        
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
    // MARK: - Table View Cell Methods
    
    func inviteCodeCell() -> InviteCodeTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
        let inviteCodeCell = tableViewCell as! InviteCodeTableViewCell
        inviteCodeCell.setInviteCode(Party.inviteCode)
        return inviteCodeCell
    }
    
    func partyGameHeaderCell() -> HeaderTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
        let headerCell = tableViewCell as! HeaderTableViewCell
        headerCell.setBackgroundColor(UIColor.Partybox.green)
        headerCell.setHeader("GAME")
        headerCell.setEmoji("🎉")
        return headerCell
    }
    
    func partyGameCell() -> GameTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
        let partyGameCell = tableViewCell as! GameTableViewCell
        return partyGameCell
    }
    
    func waitingForHostToStartGameCell() -> WaitingTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: WaitingTableViewCell.identifier)
        let waitingCell = tableViewCell as! WaitingTableViewCell
        waitingCell.setPrompt("Waiting for Host to Start Game")
        return waitingCell
    }
    
    func startGameChangeGameButtonsCell(delegate: DoubleButtonTableViewCellDelegate) -> DoubleButtonTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: DoubleButtonTableViewCell.identifier)
        let doubleButtonCell = tableViewCell as! DoubleButtonTableViewCell
        doubleButtonCell.setTopButtonTitle("Start Game")
        doubleButtonCell.setBottomButtonTitle("Change Game")
        doubleButtonCell.delegate = delegate
        return doubleButtonCell
    }
    
    func partyPeopleHeaderCell() -> HeaderTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
        let headerCell = tableViewCell as! HeaderTableViewCell
        headerCell.setBackgroundColor(UIColor.Partybox.green)
        headerCell.setHeader("PEOPLE")
        headerCell.setEmoji("🎉")
        return headerCell
    }
    
    func partyPersonCell(partyPerson: PartyPerson) -> PersonTableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
        let partyPersonCell = tableViewCell as! PersonTableViewCell
        partyPersonCell.setName(partyPerson.name)
        partyPersonCell.setFlair(partyPerson.name)
        partyPersonCell.setEmoji(partyPerson.emoji)
        partyPersonCell.setPoints(partyPerson.points)
        return partyPersonCell
    }
    
}

extension PartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartyView.staticTableViewCellCount + Party.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.inviteCodeCell()
        }
        
        if indexPath.row == 1 {
            return self.partyGameHeaderCell()
        }
        
        if indexPath.row == 2 {
            return self.partyGameCell()
        }
        
        if indexPath.row == 3 {
            if Party.userHost {
                return self.startGameChangeGameButtonsCell(delegate: self)
            }
            else {
                return self.waitingForHostToStartGameCell()
            }
        }
        
        if indexPath.row == 4 {
            return self.partyPeopleHeaderCell()
        }
            
        if indexPath.row > 4 {
            let index = indexPath.row - PartyView.staticTableViewCellCount
            
            let partyPerson = Party.people.person(index: index)
            
            return self.partyPersonCell(partyPerson: partyPerson)
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: DoubleButtonTableViewCellDelegate {
    
    // MARK: - Double Button Table View Cell Delegate Methods
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, topButtonPressed button: UIButton) {
        self.delegate.partyView(self, startGameButtonPressed: button)
    }
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, bottomButtonPressed button: UIButton) {
        self.delegate.partyView(self, changeGameButtonPressed: button)
    }
    
}
