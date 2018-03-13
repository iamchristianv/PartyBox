//
//  PlayWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PlayWannabeViewDelegate {
    
    // MARK: - Play Wannabe View Delegate Functions
    
    func playWannabeView(_ playWannabeView: PlayWannabeView, countdownEnded minutes: Int)
    
}

class PlayWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2

    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(GameCountdownTableViewCell.self, forCellReuseIdentifier: GameCountdownTableViewCell.identifier)
        tableView.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var delegate: PlayWannabeViewDelegate!
    
    // MARK: - Initialization Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.backgroundColor = .white
    }
    
    func setupSubviews() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
    }

}

extension PlayWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameCountdownTableViewCell.identifier)
            let customCell = tableViewCell as! GameCountdownTableViewCell
            customCell.setPrompt("COUNTDOWN")
            customCell.delegate = self
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let customCell = tableViewCell as! PromptTableViewCell
            
            if User.current.name == Wannabe.current.details.wannabeName {
                customCell.setPrompt("You're the wannabe!")
            } else {
                customCell.setPrompt("You're NOT the wannabe!")
            }
            
            return customCell
        }
        
        return UITableViewCell()
    }
    
}

extension PlayWannabeView: GameCountdownTableViewCellDelegate {
    
    // MARK: - Game Countdown Table View Cell Delegate Functions
    
    func gameCountdownTableViewCell(_ gameCountdownTableViewCell: GameCountdownTableViewCell, countdownEnded minutes: Int) {
        self.delegate.playWannabeView(self, countdownEnded: minutes)
    }
    
}
