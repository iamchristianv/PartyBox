//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PartyViewDelegate {
    
    // MARK: - Party View Delegate Methods
    
    func partyView(_ partyView: PartyView, startGameButtonPressed startGameButton: UIButton)
    
    func partyView(_ partyView: PartyView, changeGameButtonPressed changeGameButton: UIButton)

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
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(ButtonCollectionTableViewCell.self, forCellReuseIdentifier: ButtonCollectionTableViewCell.identifier)
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
        super.init(frame: frame)
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
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let inviteCodeCell = tableViewCell as! InviteCodeTableViewCell
            return inviteCodeCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let headerCell = tableViewCell as! HeaderTableViewCell
            headerCell.setBackgroundColor(UIColor.Partybox.green)
            headerCell.setHeader("GAME")
            return headerCell
        }
        
        if indexPath.row == 2 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let partyGameCell = tableViewCell as! GameTableViewCell
            return partyGameCell
        }
        
        if indexPath.row == 3 {
            if Party.userHost {
                let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ButtonCollectionTableViewCell.identifier)
                let buttonCollectionCell = tableViewCell as! ButtonCollectionTableViewCell
                buttonCollectionCell.setLeftButtonTitle("Start")
                buttonCollectionCell.setRightButtonTitle("Change")
                buttonCollectionCell.delegate = self
                return buttonCollectionCell
            }
            else {
                let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier)
                let activityCell = tableViewCell as! ActivityTableViewCell
                activityCell.setPrompt("Waiting for Host to Start Game")
                return activityCell
            }
        }
        
        if indexPath.row == 4 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let headerCell = tableViewCell as! HeaderTableViewCell
            headerCell.setBackgroundColor(UIColor.Partybox.green)
            headerCell.setHeader("PEOPLE")
            return headerCell
        }
            
        if indexPath.row > 4 {
            let index = indexPath.row - PartyView.staticTableViewCellCount
            
            let partyPerson = Party.people.person(index: index)
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
            let partyPersonCell = tableViewCell as! PersonTableViewCell
            partyPersonCell.setName(partyPerson.name)
            partyPersonCell.setFlair(partyPerson.name)
            partyPersonCell.setEmoji(partyPerson.emoji)
            partyPersonCell.setPoints(partyPerson.points)
            return partyPersonCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: ButtonCollectionTableViewCellDelegate {
    
    // MARK: - Button Collection Table View Cell Delegate Methods
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, leftButtonPressed button: UIButton) {
        self.delegate.partyView(self, startGameButtonPressed: button)
    }

    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, rightButtonPressed button: UIButton) {
        self.delegate.partyView(self, changeGameButtonPressed: button)
    }
    
}
