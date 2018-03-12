//
//  StartWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol StartWannabeViewDelegate {
    
    // MARK: - Start Wannabe View Delegate Functions
    
    func startWannabeView(_ startWannabeView: StartWannabeView, readyButtonPressed: Bool)
    
}

class StartWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 1
    
    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(GameInstructionsTableViewCell.self, forCellReuseIdentifier: GameInstructionsTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var readyButton: ActivityButton = {
        let readyButton = ActivityButton()
        readyButton.setTitle("Ready", for: .normal)
        readyButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        readyButton.setBackgroundColor(UIColor.Partybox.green)
        readyButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        return readyButton
    }()
    
    var delegate: StartWannabeViewDelegate!
    
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
        self.addSubview(self.readyButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.readyButton.snp.top).offset(-32)
        })
        
        self.readyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func readyButtonPressed() {
        self.delegate.startWannabeView(self, readyButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    // MARK: - Animation Functions
    
    func startAnimatingReadyButton() {
        self.readyButton.startAnimating()
    }
    
    func stopAnimatingReadyButton() {
        self.readyButton.stopAnimating()
    }

}

extension StartWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StartWannabeView.staticTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: GameInstructionsTableViewCell.identifier)
            let customCell = tableViewCell as! GameInstructionsTableViewCell
            customCell.setName(Wannabe.current.details.name)
            customCell.setInstructions(Wannabe.current.details.instructions)
            return customCell
        }

        return UITableViewCell()
    }
    
}
