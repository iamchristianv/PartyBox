//
//  BaseTableView.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.name)
        self.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.name)
        self.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.name)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
