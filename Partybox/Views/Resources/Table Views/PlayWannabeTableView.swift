//
//  PlayWannabeTableView.swift
//  Partybox
//
//  Created by Christian Villa on 12/27/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PlayWannabeTableView: UITableView {
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        self.register(GameCountdownTableViewCell.self, forCellReuseIdentifier: GameCountdownTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Cell Methods
    
    func countdownCell(delegate: GameCountdownTableViewCellDelegate) -> GameCountdownTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: GameCountdownTableViewCell.identifier)
        let gameCountdownCell = tableViewCell as! GameCountdownTableViewCell
        gameCountdownCell.setPrompt("COUNTDOWN")
        gameCountdownCell.delegate = delegate
        return gameCountdownCell
    }
    
    func actionCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        
        if Party.userName == Party.game.details.wannabe {
            promptCell.setPrompt("You're the wannabe!\n\n" + Party.game.details.card.type)
        }
        else {
            promptCell.setPrompt("You're NOT the wannabe!\n\n" + Party.game.details.card.content)
        }
        
        return promptCell
    }

}
