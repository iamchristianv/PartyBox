//
//  StartWannabeTableView.swift
//  Partybox
//
//  Created by Christian Villa on 12/27/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartWannabeTableView: UITableView {
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(GameInstructionsTableViewCell.self, forCellReuseIdentifier: GameInstructionsTableViewCell.identifier)
        self.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        self.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Cell Methods

    func instructionsCell() -> GameInstructionsTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: GameInstructionsTableViewCell.identifier)
        let gameInstructionsCell = tableViewCell as! GameInstructionsTableViewCell
        return gameInstructionsCell
    }
    
    func readyToPlayButtonCell(delegate: ButtonTableViewCellDelegate) -> ButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier)
        let buttonCell = tableViewCell as! ButtonTableViewCell
        buttonCell.setButtonTitle("Ready to Play")
        buttonCell.delegate = delegate
        return buttonCell
    }
    
    func waitingForEveryoneToBeReadyCell() -> ActivityTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier)
        let activityCell = tableViewCell as! ActivityTableViewCell
        activityCell.setPrompt("Waiting for Everyone to be Ready")
        return activityCell
    }

}
