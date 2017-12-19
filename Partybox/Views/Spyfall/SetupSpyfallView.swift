//
//  SetupSpyfallView.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol SetupSpyfallViewDelegate {
    
    func setupSpyfallView(_ setupSpyfallView: SetupSpyfallView, playGameButtonPressed button: UIButton)
    
}

class SetupSpyfallView: BaseView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2

    // MARK: - Instance Properties
    
    lazy var tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: SetupSpyfallViewDelegate!
    
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

extension SetupSpyfallView: UITableViewDelegate {
    
}

extension SetupSpyfallView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetupSpyfallView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return UITableViewCell()
        }
        
        if indexPath.row == 1 {
            return self.tableView.playGameButtonCell(delegate: self)
        }

        return UITableViewCell()
    }
    
}

extension SetupSpyfallView: SingleButtonTableViewCellDelegate {
    
    // MARK: - Button Table View Cell Delegate Methods
    
    func singleButtonTableViewCell(_ singleButtonTableViewCell: SingleButtonTableViewCell, buttonPressed button: UIButton) {
        self.delegate.setupSpyfallView(self, playGameButtonPressed: button)
    }
    
}
