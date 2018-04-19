//
//  EndWannabeTableView.swift
//  Partybox
//
//  Created by Christian Villa on 12/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class EndWannabeTableView: UITableView {

    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        self.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Cell Methods
    
    func everyoneWonPromptCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        promptCell.setPrompt("Everyone figured out who the wannabe was!\n\nEveryone wins!")
        return promptCell
    }
    
    func wannabeWonPromptCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        promptCell.setPrompt("Nobody figured out who the wannabe was!\n\nThe wannabe wins!")
        return promptCell
    }
    
    func pointsWonCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        guard let person = Game.current.wannabe.people.person(name: User.current.name) else { return promptCell }
        promptCell.setPrompt("You earned \(person.points) points from playing!")
        return promptCell 
    }
    
    func backToPartyButtonCell(delegate: ButtonTableViewCellDelegate) -> ButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier)
        let buttonCell = tableViewCell as! ButtonTableViewCell
        buttonCell.setButtonTitle("Back to Party")
        buttonCell.delegate = delegate
        return buttonCell
    }

}
