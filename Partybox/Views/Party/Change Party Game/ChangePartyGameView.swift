//
//  ChangePartyGameView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyGameView: UIView {
    
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

    private lazy var saveButton: ActivityIndicatorButton = {
        let saveButton = ActivityIndicatorButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        saveButton.setTitleColor(Partybox.colors.white, for: .normal)
        saveButton.setBackgroundColor(Partybox.colors.green)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return saveButton
    }()

    var partyGameId: String!
    
    private var delegate: ChangePartyGameViewDelegate!

    private var dataSource: ChangePartyGameViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: ChangePartyGameViewDelegate, dataSource: ChangePartyGameViewDataSource) -> ChangePartyGameView {
        let view = ChangePartyGameView()
        view.partyGameId = dataSource.changePartyGameViewPartyGameId()
        view.delegate = delegate
        view.dataSource = dataSource
        view.setupView()
        return view
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
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions

    @objc private func saveButtonPressed() {
        self.delegate.changePartyGameView(self, saveButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingSaveButton() {
        self.saveButton.startAnimating()
    }

    func stopAnimatingSaveButton() {
        self.saveButton.stopAnimating()
    }
    
    // MARK: - View Functions
    
    func reloadTable() {
        self.tableView.reloadData()
    }

}

extension ChangePartyGameView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let selectableCell = tableViewCell as! SelectableTableViewCell
        self.partyGameId = selectableCell.value as! String
        self.tableView.reloadData()
    }
    
}

extension ChangePartyGameView: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangePartyGameViewCellRow.partyGameCells.rawValue + self.dataSource.changePartyGameViewPartyGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ChangePartyGameViewCellRow.promptCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let promptCell = tableViewCell as! PromptTableViewCell
            let prompt = "Which game do you want to play?"
            promptCell.configure(prompt: prompt)
            return promptCell
        }
        
        if indexPath.row == ChangePartyGameViewCellRow.partyGameHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let partyGameHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "GAMES"
            partyGameHeaderCell.configure(header: header)
            return partyGameHeaderCell
        }
        
        if indexPath.row >= ChangePartyGameViewCellRow.partyGameCells.rawValue {
            let index = indexPath.row - ChangePartyGameViewCellRow.partyGameCells.rawValue

            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let selectableCell = tableViewCell as! SelectableTableViewCell
            let content = self.dataSource.changePartyGameViewPartyGameName(index: index)
            let selected = self.dataSource.changePartyGameViewPartyGameId(index: index) == self.partyGameId
            let value = self.dataSource.changePartyGameViewPartyGameId(index: index)
            selectableCell.configure(content: content, selected: selected, value: value)
            return selectableCell
        }
        
        return UITableViewCell()
    }
    
}
