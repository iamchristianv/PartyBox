//
//  StartWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol StartWannabeViewDelegate {
    
    func startWannabeView(_ startWannabeView: StartWannabeView, readyToPlayButtonPressed button: UIButton)
    
}

class StartWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2
    
    // MARK: - Instance Properties
    
    lazy var tableView: StartWannabeTableView = {
        let tableView = StartWannabeTableView()
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: StartWannabeViewDelegate!
    
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

extension StartWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StartWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.instructionsCell()
        }
        
        if indexPath.row == 1 {
            guard let person = Party.current.people.person(name: User.current.name) else { return UITableViewCell() }
            
            if !person.isReady {
                return self.tableView.readyToPlayButtonCell(delegate: self)
            }
            else {
                return self.tableView.waitingForEveryoneToBeReadyCell()
            }
        }

        return UITableViewCell()
    }
    
}

extension StartWannabeView: ButtonTableViewCellDelegate {
    
    // MARK: - Button Table View Cell Delegate Methods
    
    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed button: UIButton) {
        self.delegate.startWannabeView(self, readyToPlayButtonPressed: button)
    }
    
}

