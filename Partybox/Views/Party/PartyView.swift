//
//  PartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PartyViewDelegate {
    
    func partyView(_ partyView: PartyView, startGameButtonPressed startGameButton: UIButton)
    
    func partyView(_ partyView: PartyView, changeGameButtonPressed startGameButton: UIButton)

}

class PartyView: BaseView {
    
    // MARK: - Class Properties
    
    static let staticTableViewCellCount: Int = 5

    // MARK: - Instance Properties
    
    lazy var tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var delegate: PartyViewDelegate!
        
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

extension PartyView: UITableViewDelegate {
    
}

extension PartyView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PartyView.staticTableViewCellCount + Session.party.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView.inviteCodeCell()
        }
        
        if indexPath.row == 1 {
            return self.tableView.partyGameHeaderCell()
        }
        
        if indexPath.row == 2 {
            return self.tableView.partyGameCell()
        }
        
        if indexPath.row == 3 {
            if Session.host {
                return self.tableView.startGameChangeGameButtonsCell(delegate: self)
            }
            else {
                return self.tableView.waitingForHostToStartGameCell()
            }
        }
        
        if indexPath.row == 4 {
            return self.tableView.partyPeopleHeaderCell()
        }
            
        if indexPath.row > 4 {
            let index = indexPath.row - PartyView.staticTableViewCellCount
            
            guard let partyPerson = Session.party.people.person(index: index) else {
                return UITableViewCell()
            }
            
            return self.tableView.partyPersonCell(partyPerson: partyPerson)
        }
        
        return UITableViewCell()
    }
    
}

extension PartyView: DoubleButtonTableViewCellDelegate {
    
    // MARK: - Double Button Table View Cell Delegate Methods
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, topButtonPressed button: UIButton) {
        self.delegate.partyView(self, startGameButtonPressed: button)
    }
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, bottomButtonPressed button: UIButton) {
        self.delegate.partyView(self, changeGameButtonPressed: button)
    }
    
}
