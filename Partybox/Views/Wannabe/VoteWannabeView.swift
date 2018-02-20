//
//  VoteWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 12/19/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol VoteWannabeViewDelegate {
    
    func voteWannabeView(_ voteWannabeView: VoteWannabeView, voteButtonPressed button: UIButton, forName name: String)
    
}

class VoteWannabeView: UIView    {

    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 2
    
    // MARK: - Instance Properties
    
    lazy var tableView: VoteWannabeTableView = {
        let tableView = VoteWannabeTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var name: String?
    
    var delegate: VoteWannabeViewDelegate!
    
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

extension VoteWannabeView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        self.name = tableViewCell?.textLabel?.text
    }
    
}

extension VoteWannabeView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VoteWannabeView.staticTableViewCellCount + Game.wannabe.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.votePromptCell()
        }
        
        if indexPath.row > 0 && indexPath.row <= Game.wannabe.people.count {
            let index = indexPath.row - 1
            
            guard let person = Game.wannabe.people.person(index: index) else { return UITableViewCell() }
            
            return self.tableView.wannabePersonCell(wannabePerson: person)
        }
        
        if indexPath.row == Game.wannabe.people.count + 1 {
            guard let person = Game.wannabe.people.person(name: User.current.name) else { return UITableViewCell() }
            
            if person.voteName.isEmpty {
                return self.tableView.voteButtonCell(delegate: self)
            }
            else {
                return self.tableView.waitingForEveryoneToVoteCell()
            }
        }
        
        return UITableViewCell()
    }
    
}

extension VoteWannabeView: ButtonTableViewCellDelegate {
    
    // MARK: - Button Table View Cell Methods
    
    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed button: UIButton) {
        if let name = self.name {
            self.delegate.voteWannabeView(self, voteButtonPressed: button, forName: name)
        }
    }
    
}
