//
//  ChangePartyHostView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyHostView: UIView {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
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

    private lazy var saveButton: ActivityIndicatorButton = {
        let saveButton = ActivityIndicatorButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 22)
        saveButton.setTitleColor(Partybox.color.white, for: .normal)
        saveButton.setBackgroundColor(Partybox.color.green)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return saveButton
    }()

    private var delegate: ChangePartyHostViewDelegate!

    private var dataSource: ChangePartyHostViewDataSource!

    // MARK: - Initialization Functions

    init(delegate: ChangePartyHostViewDelegate, dataSource: ChangePartyHostViewDataSource) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.dataSource = dataSource
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.tableView)
        self.addSubview(self.saveButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.saveButton.snp.top).offset(-32)
        })
        
        self.saveButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-40)
        })
    }
    
    // MARK: - Action Functions
    
    @objc private func saveButtonPressed() {
        self.delegate.changePartyHostView(self, saveButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }

}

extension ChangePartyHostView: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let selectableCell = tableViewCell as! SelectableTableViewCell
        self.delegate.changePartyHostView(self, personSelected: selectableCell.value as! String)
    }
    
}

extension ChangePartyHostView: UITableViewDataSource {
        
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangePartyHostViewCellRow.partyGuestCells.rawValue + self.dataSource.changePartyHostViewPartyPersonsCount()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ChangePartyHostViewCellRow.promptCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let promptCell = tableViewCell as! PromptTableViewCell
            let prompt = "Who should be the host?"
            promptCell.configure(prompt: prompt)
            return promptCell
        }

        if indexPath.row == ChangePartyHostViewCellRow.partyGuestsHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyPeopleHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GUESTS"
            partyPeopleHeaderCell.configure(header: header)
            return partyPeopleHeaderCell
        }

        if indexPath.row >= ChangePartyHostViewCellRow.partyGuestCells.rawValue {
            let index = indexPath.row - ChangePartyHostViewCellRow.partyGuestCells.rawValue

            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let selectableCell = tableViewCell as! SelectableTableViewCell
            let content = self.dataSource.changePartyHostViewPartyPersonName(index: index)
            let selected = self.dataSource.changePartyHostViewPartyPersonId(index: index) == self.dataSource.changePartyHostViewPartyHostId()
            let value = self.dataSource.changePartyHostViewPartyPersonId(index: index)
            selectableCell.configure(content: content, selected: selected, value: value)
            return selectableCell
        }
        
        return UITableViewCell()
    }
    
}
