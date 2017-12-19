//
//  PlaySpyfallView.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PlaySpyfallViewDelegate {
    
    func playSpyfallView(_ playSpyfallView: PlaySpyfallView, countdownEnded minutes: Int)
    
}

class PlaySpyfallView: BaseView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 5

    // MARK: - Instance Properties
    
    lazy var tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: PlaySpyfallViewDelegate!
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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

extension PlaySpyfallView: UITableViewDelegate {
    
}

extension PlaySpyfallView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaySpyfallView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.spyfallCountdownCell(delegate: self)
        }
        
        if indexPath.row == 1 {
            return UITableViewCell()
        }
        
        if indexPath.row == 2 {
            return UITableViewCell()
        }
        
        if indexPath.row == 3 {
            return UITableViewCell()
        }
        
        if indexPath.row == 4 {
            return UITableViewCell()
        }
        
        if indexPath.row > 4 {
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
}

extension PlaySpyfallView: GameCountdownTableViewCellDelegate {
    
    // MARK: - Game Countdown Table View Cell Delegate Methods
    
    func gameCountdownTableViewCell(_ gameCountdownTableViewCell: GameCountdownTableViewCell, countdownEnded minutes: Int) {
        self.delegate.playSpyfallView(self, countdownEnded: minutes)
    }
    
}
