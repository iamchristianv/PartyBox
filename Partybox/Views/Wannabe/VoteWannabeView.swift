//
//  VoteWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol VoteWannabeViewDelegate {
    
    // MARK: - Vote Wannabe View Delegate Functions
    
    func voteWannabeView(_ voteWannabeView: VoteWannabeView, voteButtonPressed: Bool)
    
}

class VoteWannabeView: UIView    {

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
        tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: SelectableTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    var selectedPersonName: String = User.current.name
    
    lazy var voteButton: ActivityButton = {
        let voteButton = ActivityButton()
        voteButton.setTitle("Vote", for: .normal)
        voteButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        voteButton.setBackgroundColor(UIColor.Partybox.green)
        voteButton.addTarget(self, action: #selector(voteButtonPressed), for: .touchUpInside)
        return voteButton
    }()
    
    var delegate: VoteWannabeViewDelegate!
    
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
        self.addSubview(self.voteButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.voteButton.snp.top).offset(-32)
        })
        
        self.voteButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func voteButtonPressed() {
        self.delegate.voteWannabeView(self, voteButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func selectedPersonNameValue() -> String {
        return self.selectedPersonName
    }
    
    // MARK: - Animation Functions
    
    func startAnimatingVoteButton() {
        self.voteButton.startAnimating()
    }
    
    func stopAnimatingVoteButton() {
        self.voteButton.stopAnimating()
    }

}

extension VoteWannabeView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let customCell = tableViewCell as! SelectableTableViewCell
        
        self.selectedPersonName = customCell.contentLabel.text!
        self.reloadTable()
    }
    
}

extension VoteWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VoteWannabeView.staticTableViewCellCount + Wannabe.current.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let customCell = tableViewCell as! PromptTableViewCell
            customCell.setPrompt("Select the person you think is the wannabe")
            return customCell
        }
        
        if indexPath.row == 1 {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let customCell = tableViewCell as! HeaderTableViewCell
            customCell.setHeader("PEOPLE")
            customCell.setBackgroundColor(UIColor.Partybox.green)
            return customCell
        }
        
        if indexPath.row > 1 {
            let index = indexPath.row - VoteWannabeView.staticTableViewCellCount
            
            guard let person = Wannabe.current.people.person(index: index) else { return UITableViewCell() }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let customCell = tableViewCell as! SelectableTableViewCell
            customCell.setContent(person.name)
            customCell.setSelected(person.name == self.selectedPersonName)
            return customCell
        }
        
        return UITableViewCell()
    }
    
}
