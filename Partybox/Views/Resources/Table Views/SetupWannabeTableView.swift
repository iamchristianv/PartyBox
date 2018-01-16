//
//  SetupWannabeTableView.swift
//  Partybox
//
//  Created by Christian Villa on 12/27/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class SetupWannabeTableView: UITableView {

    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Cell Methods
    
    func playGameButtonCell(delegate: ButtonTableViewCellDelegate) -> ButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier)
        let buttonCell = tableViewCell as! ButtonTableViewCell
        buttonCell.setButtonTitle("Play Game")
        buttonCell.delegate = delegate
        return buttonCell
    }

}
