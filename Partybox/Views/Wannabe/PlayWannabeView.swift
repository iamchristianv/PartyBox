//
//  PlayWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PlayWannabeViewDelegate {
    
    func playWannabeView(_ playWannabeView: PlayWannabeView, countdownEnded minutes: Int)
    
}

class PlayWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2

    // MARK: - Instance Properties
    
    lazy var tableView: PlayWannabeTableView = {
        let tableView = PlayWannabeTableView()
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: PlayWannabeViewDelegate!
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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

extension PlayWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.countdownCell(delegate: self)
        }
        
        if indexPath.row == 1 {
            return self.tableView.actionCell()
        }
        
        return UITableViewCell()
    }
    
}

extension PlayWannabeView: GameCountdownTableViewCellDelegate {
    
    // MARK: - Game Countdown Table View Cell Delegate Methods
    
    func gameCountdownTableViewCell(_ gameCountdownTableViewCell: GameCountdownTableViewCell, countdownEnded minutes: Int) {
        self.delegate.playWannabeView(self, countdownEnded: minutes)
    }
    
}
