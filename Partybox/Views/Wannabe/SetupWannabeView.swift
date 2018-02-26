//
//  SetupWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate Functions
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playButtonPressed: Bool)
    
}

class SetupWannabeView: UIView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 3

    // MARK: - Instance Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var playButton: ActivityButton = {
        let playButton = ActivityButton()
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        playButton.setBackgroundColor(UIColor.Partybox.green)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return playButton
    }()
    
    var delegate: SetupWannabeViewDelegate!
    
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
        self.addSubview(self.playButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.playButton.snp.top).offset(-32)
        })
        
        self.playButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func playButtonPressed() {
        self.delegate.setupWannabeView(self, playButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    // MARK: - Animation Functions
    
    func startAnimatingPlayButton() {
        self.playButton.startAnimating()
    }
    
    func stopAnimatingPlayButton() {
        self.playButton.stopAnimating()
    }
    
}

extension SetupWannabeView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    
    
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
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let customCell = tableViewCell as! PromptTableViewCell
            customCell.setPrompt("Choose how you want to play")
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setHeader("DURATION")
            customCell.setBackgroundColor(UIColor.Partybox.green)
            return customCell
        }
        
        if indexPath.row > 1 {
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
}
