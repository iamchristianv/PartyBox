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
    
    func partyView(_ partyView: PartyView, kickButtonPressed selectedPersonName: String)

}

class PartyView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 5

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
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        tableView.register(ButtonCollectionTableViewCell.self, forCellReuseIdentifier: ButtonCollectionTableViewCell.identifier)
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var delegate: PartyViewDelegate!
        
    // MARK: - Initialization Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
}

extension PartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if User.current.name != Party.current.details.hostName {
            return []
        }
        
        let index = indexPath.row - PartyView.staticTableViewCellCount
        
        guard let person = Party.current.people.person(index: index) else { return [] }
        
        if person.name == Party.current.details.hostName {
            return []
        }
        
        let kickButton = UITableViewRowAction(style: .default, title: "KICK", handler: {
            (_, indexPath) in
            
            self.delegate.partyView(self, kickButtonPressed: person.name)
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
        return PartyView.staticTableViewCellCount + Party.current.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: InviteCodeTableViewCell.identifier)
            let customCell = tableViewCell as! InviteCodeTableViewCell
            customCell.setInviteCode(Party.current.details.id)
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setBackgroundColor(UIColor.Partybox.green)
            customCell.setHeader("GAME")
            return customCell
        }
        
        if indexPath.row == 2 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier)
            let customCell = tableViewCell as! GameTableViewCell
            
            switch Game.current.type {
            case .wannabe:
                customCell.setName(Game.current.wannabe.details.name)
                customCell.setSummary(Game.current.wannabe.details.summary)
            }

            return customCell
        }
        
        if indexPath.row == 3 {
            if User.current.name == Party.current.details.hostName {
                let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ButtonCollectionTableViewCell.identifier)
                let customCell = tableViewCell as! ButtonCollectionTableViewCell
                customCell.setTopButtonTitle("Play")
                customCell.setBottomButtonTitle("Change")
                customCell.delegate = self
                return customCell
            } else {
                let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier)
                let customCell = tableViewCell as! ActivityTableViewCell
                customCell.setPrompt("Waiting for Host to Start Game")
                return customCell
            }
        }
        
        if indexPath.row == 4 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setBackgroundColor(UIColor.Partybox.green)
            customCell.setHeader("PEOPLE")
            return customCell
        }
            
        if indexPath.row > 4 {
            let index = indexPath.row - PartyView.staticTableViewCellCount
            
            guard let partyPerson = Party.current.people.person(index: index) else { return UITableViewCell() }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier)
            let customCell = tableViewCell as! PersonTableViewCell
            customCell.setName(partyPerson.name)
            customCell.setFlair(partyPerson.name)
            customCell.setEmoji(PartyPeople.randomEmoji())
            customCell.setPoints(partyPerson.points)
            return customCell
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: ButtonCollectionTableViewCellDelegate {
    
    // MARK: - Button Collection Table View Cell Delegate Functions
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, topButtonPressed button: UIButton) {
        self.delegate.partyView(self, playButtonPressed: true)
    }

    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, bottomButtonPressed button: UIButton) {
        self.delegate.partyView(self, changeButtonPressed: true)
    }
    
}
