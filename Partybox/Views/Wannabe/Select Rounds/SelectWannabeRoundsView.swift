//
//  SelectWannabeRoundsView.swift
//  Partybox
//
//  Created by Christian Villa on 5/30/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SelectWannabeRoundsView: UIView {

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

    var rounds: Int!

    private var delegate: SelectWannabeRoundsViewDelegate!

    private var dataSource: SelectWannabeRoundsViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: SelectWannabeRoundsViewDelegate, dataSource: SelectWannabeRoundsViewDataSource) -> SelectWannabeRoundsView {
        let view = SelectWannabeRoundsView()
        view.rounds = dataSource.selectWannabeRoundsViewRounds(index: 0)
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
        self.delegate.selectWannabeRoundsView(self, saveButtonPressed: true)
    }

    // MARK: - View Functions

    func reloadTable() {
        self.tableView.reloadData()
    }

}

extension SelectWannabeRoundsView: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let selectableCell = tableViewCell as! SelectableTableViewCell
        self.rounds = selectableCell.value as! Int
        self.tableView.reloadData()
    }

}

extension SelectWannabeRoundsView: UITableViewDataSource {

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectWannabeRoundsViewCellRow.roundsCells.rawValue + self.dataSource.selectWannabeRoundsViewRoundsCount()
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SelectWannabeRoundsViewCellRow.promptCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let promptCell = tableViewCell as! PromptTableViewCell
            let prompt = "How long do you want to play?"
            promptCell.configure(prompt: prompt)
            return promptCell
        }

        if indexPath.row == SelectWannabeRoundsViewCellRow.roundsHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let roundsHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "ROUNDS"
            roundsHeaderCell.configure(header: header)
            return roundsHeaderCell
        }

        if indexPath.row >= SelectWannabeRoundsViewCellRow.roundsCells.rawValue {
            let index = indexPath.row - SelectWannabeRoundsViewCellRow.roundsCells.rawValue

            let rounds = self.dataSource.selectWannabeRoundsViewRounds(index: index)

            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let selectableCell = tableViewCell as! SelectableTableViewCell
            let content = "\(rounds) Rounds"
            let selected = rounds == self.rounds
            let value = rounds
            selectableCell.configure(content: content, selected: selected, value: value)
            return selectableCell
        }

        return UITableViewCell()
    }

}
