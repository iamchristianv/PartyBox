//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 5

    // MARK: - Instance Properties
    
    var tableView: BaseTableView = {
        let tableView = BaseTableView()
        return tableView
    }()
        
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navigationBarHeight = 44 as CGFloat
            make.top.equalTo(self.snp.top).offset(statusBarHeight + navigationBarHeight)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
}

extension PartyView: UITableViewDelegate {
    
}

extension PartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartyView.staticTableViewCellCount + Session.current.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let promptCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.name) as! PromptTableViewCell
            promptCell.promptLabel.text = "Invite Code: " + Session.current.inviteCode
            return promptCell
        }
        else if indexPath.row == 1 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.name) as! HeaderTableViewCell
            headerCell.headerLabel.text = "PARTY GAME"
            headerCell.emojiLabel.text = "🎉"
            return headerCell
        }
        else if indexPath.row == 2 {
            let gameCell = self.tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.name) as! GameTableViewCell
            gameCell.nameLabel.text = Session.current.game.name
            gameCell.summaryLabel.text = "This is a sample summary for the sample game"
            return gameCell
        }
        else if indexPath.row == 3 {
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.name) as! HeaderTableViewCell
            headerCell.headerLabel.text = "PARTY PEOPLE"
            headerCell.emojiLabel.text = "🎉"
            return headerCell
        }
        else {
            return UITableViewCell()
        }
    }
    
}
