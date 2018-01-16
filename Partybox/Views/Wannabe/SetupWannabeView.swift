//
//  SetupWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol SetupWannabeViewDelegate {
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playGameButtonPressed button: UIButton)
    
}

class SetupWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 1

    // MARK: - Instance Properties
    
    lazy var tableView: SetupWannabeTableView = {
        let tableView = SetupWannabeTableView()
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: SetupWannabeViewDelegate!
    
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

extension SetupWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetupWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.playGameButtonCell(delegate: self)
        }

        return UITableViewCell()
    }
    
}

extension SetupWannabeView: ButtonTableViewCellDelegate {
    
    // MARK: - Button Table View Cell Delegate Methods
    
    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed button: UIButton) {
        self.delegate.setupWannabeView(self, playGameButtonPressed: button)
    }
    
}
