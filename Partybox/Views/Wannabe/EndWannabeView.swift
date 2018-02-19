//
//  EndWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol EndWannabeViewDelegate {
    
    func endWannabeView(_ endWannabeView: EndWannabeView, backToPartyButtonPressed button: UIButton)
    
}

class EndWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 3

    // MARK: - Instance Properties
    
    lazy var tableView: EndWannabeTableView = {
        let tableView = EndWannabeTableView()
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: EndWannabeViewDelegate!
    
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

extension EndWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EndWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if Game.wannabe.details.wannabeName.isEmpty {
                return self.tableView.everyoneWonPromptCell()
            }
            else {
                return self.tableView.wannabeWonPromptCell()
            }
        }
        
        if indexPath.row == 1 {
            return self.tableView.pointsWonCell()
        }
        
        if indexPath.row == 2 {
            return self.tableView.backToPartyButtonCell(delegate: self)
        }
        
        return UITableViewCell()
    }
    
}

extension EndWannabeView: ButtonTableViewCellDelegate {

    // MARK: - Button Table View Cell Delegate Methods
    
    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed button: UIButton) {
        self.delegate.endWannabeView(self, backToPartyButtonPressed: button)
    }
    
}
