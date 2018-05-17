//
//  ChangeHostView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeHostView: UIView {
    
    // MARK: - Instance Properties
    
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

    private lazy var saveChangesButton: ActivityIndicatorButton = {
        let saveChangesButton = ActivityIndicatorButton()
        saveChangesButton.setTitle("Save Changes", for: .normal)
        saveChangesButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        saveChangesButton.setTitleColor(Partybox.colors.white, for: .normal)
        saveChangesButton.setBackgroundColor(Partybox.colors.green)
        saveChangesButton.addTarget(self, action: #selector(saveChangesButtonPressed), for: .touchUpInside)
        return saveChangesButton
    }()

    private var selectedHostName: String!
    
    private var delegate: ChangeHostViewDelegate!

    private var dataSource: ChangeHostViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: ChangeHostViewDelegate, dataSource: ChangeHostViewDataSource) -> ChangeHostView {
        let view = ChangeHostView()
        view.delegate = delegate
        view.dataSource = dataSource
        view.selectedHostName = dataSource.changeHostViewHostName()
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.tableView)
        self.addSubview(self.saveChangesButton)
        
        self.tableView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.saveChangesButton.snp.top).offset(-32)
        })
        
        self.saveChangesButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func saveChangesButtonPressed() {
        self.delegate.changeHostView(self, saveChangesButtonPressed: true)
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func hostName() -> String {
        return self.selectedHostName
    }

}

extension ChangeHostView: UITableViewDelegate {
    
    // MARK: - Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let selectableCell = tableViewCell as! SelectableTableViewCell
        self.selectedHostName = selectableCell.content()

        self.tableView.reloadData()
    }
    
}

extension ChangeHostView: UITableViewDataSource {
    
    // MARK: - Table View Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangeHostViewCellRow.personCells.rawValue + self.dataSource.changeHostViewPeopleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ChangeHostViewCellRow.promptCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let promptCell = tableViewCell as! PromptTableViewCell
            let prompt = "Choose a new person to be the host"
            promptCell.configure(prompt: prompt)
            return promptCell
        }
        
        if indexPath.row == ChangeHostViewCellRow.peopleHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let headerCell = tableViewCell as! HeaderTableViewCell
            let header = "PEOPLE"
            headerCell.configure(header: header)
            return headerCell
        }
        
        if indexPath.row > 1 {
            let index = indexPath.row - ChangeHostViewCellRow.personCells.rawValue
            
            guard let person = self.dataSource.changeHostViewPerson(index: index) else {
                return UITableViewCell()
            }
            
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let selectableCell = tableViewCell as! SelectableTableViewCell
            let content = person.name
            let selected = person.name == self.selectedHostName
            selectableCell.configure(content: content, selected: selected)
            return selectableCell
        }
        
        return UITableViewCell()
    }
    
}
