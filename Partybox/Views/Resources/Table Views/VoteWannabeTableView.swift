//
//  VoteWannabeTableView.swift
//  Partybox
//
//  Created by Christian Villa on 12/27/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class VoteWannabeTableView: UITableView {

    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        self.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        self.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Cell Methods
    
    func votePromptCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        promptCell.setPrompt("Choose the person you think is the wannabe!")
        return promptCell
    }
    
    func wannabePersonCell(wannabePerson: WannabePerson) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = wannabePerson.name
        return tableViewCell
    }
    
    func voteButtonCell(delegate: ButtonTableViewCellDelegate) -> ButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier)
        let buttonCell = tableViewCell as! ButtonTableViewCell
        buttonCell.setButtonTitle("Vote")
        buttonCell.delegate = delegate
        return buttonCell
    }
    
    func waitingForEveryoneToVoteCell() -> ActivityTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier)
        let activityCell = tableViewCell as! ActivityTableViewCell
        activityCell.setPrompt("Waiting for Everyone to Vote")
        return activityCell
    }

}
