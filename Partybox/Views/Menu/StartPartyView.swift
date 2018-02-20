//
//  StartPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol StartPartyViewDelegate {
    
    // MARK: - Start Party View Delegate Functions
    
    func startPartyView(_ startPartyView: StartPartyView, startButtonPressed: Bool)
    
}

class StartPartyView: UIView {

    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(StartPartyTableViewCell.self, forCellReuseIdentifier: StartPartyTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var contentCell: StartPartyTableViewCell!
    
    lazy var startButton: ActivityButton = {
        let startButton = ActivityButton()
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        startButton.setBackgroundColor(UIColor.Partybox.red)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return startButton
    }()
    
    var delegate: StartPartyViewDelegate!
    
    // MARK: - Initialization Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
        self.addSubview(self.tableView)
        self.addSubview(self.startButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.startButton.snp.top).offset(-32)
        })
        
        self.startButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func startButtonPressed() {
        self.delegate.startPartyView(self, startButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func checkPartyNameField() {
        self.contentCell.checkPartyNameField()
    }
    
    func partyNameValue() -> String? {
        return self.contentCell.partyNameValue()
    }
    
    func checkYourNameField() {
        self.contentCell.checkYourNameField()
    }
    
    func yourNameValue() -> String? {
        return self.contentCell.yourNameValue()
    }
    
    func startAnimatingStartButton() {
        self.startButton.startAnimating()
    }
    
    func stopAnimatingStartButton() {
        self.startButton.stopAnimating()
    }

}

extension StartPartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentCell.hideKeyboard() 
    }
    
}

extension StartPartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: StartPartyTableViewCell.identifier)
        self.contentCell = tableViewCell as! StartPartyTableViewCell
        return self.contentCell
    }
    
}
