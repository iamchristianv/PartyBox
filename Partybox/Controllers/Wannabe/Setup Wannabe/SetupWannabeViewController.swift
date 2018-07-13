//
//  SetupWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SetupWannabeViewController: UIViewController {

    // MARK: - Model Properties

    private var store: Store!

    private var party: Party!

    // MARK: - View Properties

    private var contentView: SetupWannabeView!

    // MARK: - Controller Properties

    var gamePackId: String!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party) -> SetupWannabeViewController {
        let controller = SetupWannabeViewController()
        controller.store = store
        controller.party = party
        controller.contentView = SetupWannabeView.construct(delegate: controller, dataSource: controller)
        controller.gamePackId = store.wannabePacks[0]?.id
        return controller
    }

    // MARK: - View Controller Functions

    override func loadView() {
        self.view = self.contentView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
    }

    // MARK: - Setup Functions

    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle("Choose Pack")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.green)
    }

    // MARK: - Navigation Bar Functions

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {

    func setupWannabeView(_ view: SetupWannabeView, packSelected packId: String) {
        self.gamePackId = packId
        self.contentView.reloadTable()
    }

    func setupWannabeView(_ view: SetupWannabeView, saveButtonPressed: Bool) {
        let viewController = StartWannabeViewController.construct(store: self.store, party: self.party)
        self.show(viewController, sender: nil)
    }

}

extension SetupWannabeViewController: SetupWannabeViewDataSource {

    func setupWannabeViewGamePackId() -> String {
        return self.gamePackId
    }

    func setupWannabeViewGamePacksCount() -> Int {
        return self.store.wannabePacks.count
    }

    func setupWannabeViewGamePack(index: Int) -> WannabePack? {
        return self.store.wannabePacks[index]
    }

}
