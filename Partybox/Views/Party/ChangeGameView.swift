//
//  ChangeGameView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeGameView: UIView {

    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2
    
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
        tableView.register(SelectableGameTableViewCell.self, forCellReuseIdentifier: SelectableGameTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var changeButton: ActivityButton = {
        let changeButton = ActivityButton()
        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        changeButton.setBackgroundColor(UIColor.Partybox.green)
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
        return changeButton
    }()
    
    var selectedCell: SelectableGameTableViewCell?
    
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
        self.addSubview(self.changeButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.changeButton.snp.top).offset(-32)
        })
        
        self.changeButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    @objc func changeButtonPressed() {
        
    }

}

extension ChangeGameView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = self.selectedCell {
            selectedCell.setSelected(false)
        }
        
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let customCell = tableViewCell as! SelectableGameTableViewCell
        
        customCell.setSelected(true)
        
        self.selectedCell = customCell
    }
    
}

extension ChangeGameView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangeGameView.staticTableViewCellCount + GameType.collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let customCell = tableViewCell as! PromptTableViewCell
            customCell.setPrompt("Choose a new game to play")
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setHeader("GAMES")
            customCell.setBackgroundColor(UIColor.Partybox.green)
            return customCell
        }
        
        if indexPath.row > 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableGameTableViewCell.identifier)
            let customCell = tableViewCell as! SelectableGameTableViewCell
            
            let index = indexPath.row - 2
            let type = GameType.collection[index]
            
            switch type {
            case .wannabe:
                customCell.setName(Game.wannabe.details.name)
                customCell.setSummary(Game.wannabe.details.summary)
            }
            
            return customCell
        }
        
        return UITableViewCell()
    }
    
}
