//
//  JoinPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol JoinPartyViewDelegate {
    
    // MARK: - Join Party View Delegate Functions
    
    func joinPartyView(_ joinPartyView: JoinPartyView, joinButtonPressed: Bool)
    
}

class JoinPartyView: UIView {
    
    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(JoinPartyTableViewCell.self, forCellReuseIdentifier: JoinPartyTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var contentCell: JoinPartyTableViewCell!

    lazy var joinButton: ActivityButton = {
        let joinButton = ActivityButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        joinButton.setBackgroundColor(UIColor.Partybox.blue)
        joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        return joinButton
    }()
    
    var delegate: JoinPartyViewDelegate!
    
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
        self.addSubview(self.joinButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.joinButton.snp.top).offset(-32)
        })
        
        self.joinButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func joinButtonPressed() {
        self.delegate.joinPartyView(self, joinButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func inviteCodeValue() -> String? {
        return self.contentCell.inviteCodeValue()
    }
    
    func yourNameValue() -> String? {
        return self.contentCell.yourNameValue()
    }
    
    func startAnimatingJoinButton() {
        self.joinButton.startAnimating()
    }
    
    func stopAnimatingJoinButton() {
        self.joinButton.stopAnimating()
    }
    
}

extension JoinPartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentCell.hideKeyboard()
    }
    
}

extension JoinPartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: JoinPartyTableViewCell.identifier)
        self.contentCell = tableViewCell as! JoinPartyTableViewCell
        return self.contentCell
    }
    
}
