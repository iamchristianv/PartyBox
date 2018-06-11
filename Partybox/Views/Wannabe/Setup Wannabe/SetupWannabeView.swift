//
//  SetupWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SetupWannabeView: UIView {

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

    var gamePack: WannabePack!

    private var delegate: SetupWannabeViewDelegate!

    private var dataSource: SetupWannabeViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: SetupWannabeViewDelegate, dataSource: SetupWannabeViewDataSource) -> SetupWannabeView {
        let view = SetupWannabeView()
        view.gamePack = dataSource.setupWannabeViewGamePack(index: 0)
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
        self.delegate.setupWannabeView(self, saveButtonPressed: true)
    }

    // MARK: - View Functions

    func reloadTable() {
        self.tableView.reloadData()
    }

}

extension SetupWannabeView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = self.tableView.cellForRow(at: indexPath)
        let selectableCell = tableViewCell as! SelectableTableViewCell
        self.gamePack = selectableCell.value as! WannabePack
        self.tableView.reloadData()
    }

}

extension SetupWannabeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetupWannabeViewCellRow.gamePackCells.rawValue + self.dataSource.setupWannabeViewGamePacksCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SetupWannabeViewCellRow.promptCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
            let promptCell = tableViewCell as! PromptTableViewCell
            let prompt = "Which pack do you want to play with?"
            promptCell.configure(prompt: prompt)
            return promptCell
        }

        if indexPath.row == SetupWannabeViewCellRow.gamePacksHeaderCell.rawValue {
            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
            let packsHeaderCell = tableViewCell as! HeaderTableViewCell
            let header = "PACKS"
            packsHeaderCell.configure(header: header)
            return packsHeaderCell
        }

        if indexPath.row >= SetupWannabeViewCellRow.gamePackCells.rawValue {
            let index = indexPath.row - SetupWannabeViewCellRow.gamePackCells.rawValue

            guard let gamePack = self.dataSource.setupWannabeViewGamePack(index: index) else {
                return UITableViewCell()
            }

            let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier)
            let selectableCell = tableViewCell as! SelectableTableViewCell
            let content = gamePack.details.name
            let selected = gamePack.details.id == self.gamePack.details.id
            let value = gamePack
            selectableCell.configure(content: content, selected: selected, value: value)
            return selectableCell
        }

        return UITableViewCell()
    }

}
