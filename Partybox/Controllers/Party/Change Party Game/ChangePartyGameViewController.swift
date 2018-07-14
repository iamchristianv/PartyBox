//
//  ChangePartyGameViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyGameViewController: UIViewController {

    // MARK: - Model Properties

    private var store: Store!

    private var party: Party!

    // MARK: - View Properties
    
    private var contentView: ChangePartyGameView!

    // MARK: - Controller Properties

    private var partyGameId: String!

    private var delegate: ChangePartyGameViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyGameViewControllerDelegate) -> ChangePartyGameViewController {
        let controller = ChangePartyGameViewController()
        controller.store = store
        controller.party = party
        controller.contentView = ChangePartyGameView.construct(delegate: controller, dataSource: controller)
        controller.partyGameId = party.gameId
        controller.delegate = delegate
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
        self.setNavigationBarTitle("Change Game")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.green)
    }
    
    // MARK: - Action Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChangePartyGameViewController: ChangePartyGameViewDelegate {

    func changePartyGameView(_ view: ChangePartyGameView, gameChanged gameId: String) {
        self.party.gameId = gameId
        self.contentView.reloadTable()
    }

    func changePartyGameView(_ view: ChangePartyGameView, saveButtonPressed: Bool) {
        if self.partyGameId == self.party.gameId {
            let subject = "Woah there"
            let message = "Please select a new game"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            return
        }

        self.contentView.startAnimatingSaveButton()

        if self.partyGameId == PartyGame.wannabeId {
            let wannabe = Wannabe.construct(partyId: self.party.id)

            wannabe.start(callback: {
                (error) in

                self.contentView.stopAnimatingSaveButton()

                if let error = error {
                    let subject = "Oh no"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                    return
                }

                self.delegate.changePartyGameViewController(self, gameChanged: true)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}

extension ChangePartyGameViewController: ChangePartyGameViewDataSource {

    func changePartyGameViewPartyGameId() -> String {
        return self.partyGameId
    }

    func changePartyGameViewPartyGamesCount() -> Int {
        return Partybox.collection.games.count
    }

    func changePartyGameViewPartyGame(index: Int) -> PartyGame? {
        return Partybox.collection.games[self.partyGameId]
    }

}
