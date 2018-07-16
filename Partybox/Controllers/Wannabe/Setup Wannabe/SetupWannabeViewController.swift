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

    // MARK: - Controller Properties

    var gamePackId: String!

    // MARK: - View Properties

    private var contentView: SetupWannabeView!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party) -> SetupWannabeViewController {
        let controller = SetupWannabeViewController()
        // Model Properties
        controller.store = store
        controller.party = party
        // Controller Properties
        controller.gamePackId = store.wannabePacks[0]?.id
        // View Properties
        controller.contentView = SetupWannabeView.construct(delegate: controller, dataSource: controller)
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
        self.store.fetchCards(gameId: self.party.gameId, packId: self.gamePackId, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.party.game = Wannabe.construct(partyId: self.party.id)


            let viewController = StartWannabeViewController.construct(store: self.store, party: self.party)
            self.show(viewController, sender: nil)
        })
    }

}

extension SetupWannabeViewController: SetupWannabeViewDataSource {

    func setupWannabeViewGamePackId() -> String {
        guard let gamePackId = self.gamePackId else {
            return Partybox.value.none
        }

        return gamePackId
    }

    func setupWannabeViewGamePacksCount() -> Int {
        return self.store.wannabePacks.count
    }

    func setupWannabeViewGamePack(index: Int) -> WannabePack {
        guard let pack = self.store.wannabePacks[index] else {
            return WannabePack()
        }

        return pack
    }

}
