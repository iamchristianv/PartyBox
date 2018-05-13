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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewTapped)))
        tableView.register(StartPartyTableViewCell.self, forCellReuseIdentifier: StartPartyTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()

    private lazy var startButton: ActivityIndicatorButton = {
        let startButton = ActivityIndicatorButton()
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        startButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        startButton.setBackgroundColor(UIColor.Partybox.red)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return startButton
    }()
    
    private var contentCell: StartPartyTableViewCell!
    
    var delegate: StartPartyViewDelegate!

    // MARK: - Construction Functions

    static func construct(delegate: StartPartyViewDelegate) -> StartPartyView {
        let view = StartPartyView()
        view.delegate = delegate
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.backgroundColor = .white

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
    
    @objc private func tableViewTapped() {
        self.contentCell.hideKeyboard()
    }
    
    @objc private func startButtonPressed() {
        let partyNameHasErrors = self.contentCell.partyNameHasErrors()
        let userNameHasErrors = self.contentCell.userNameHasErrors()

        if partyNameHasErrors || userNameHasErrors {
            return
        }

        self.delegate.startPartyView(self, startButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingStartButton() {
        self.startButton.startAnimating()
    }

    func stopAnimatingStartButton() {
        self.startButton.stopAnimating()
    }
    
    // MARK: - View Functions
    
    func partyName() -> String {
        return self.contentCell.partyName()
    }
    
    func userName() -> String {
        return self.contentCell.userName()
    }

}

extension StartPartyView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentCell.hideKeyboard()
    }
    
}

extension StartPartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: StartPartyTableViewCell.identifier)
        self.contentCell = tableViewCell as! StartPartyTableViewCell
        self.contentCell.configure()
        return self.contentCell
    }
    
}
