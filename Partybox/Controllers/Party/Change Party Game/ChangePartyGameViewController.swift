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

    // MARK: - Controller Properties

    private var partyGameId: String!

    private var delegate: ChangePartyGameViewControllerDelegate!

    // MARK: - View Properties
    
    private var contentView: ChangePartyGameView!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyGameViewControllerDelegate) -> ChangePartyGameViewController {
        let controller = ChangePartyGameViewController()
        // Model Properties
        controller.store = store
        controller.party = party
        // Controller Properties
        controller.partyGameId = party.gameId
        controller.delegate = delegate
        // View Properties
        controller.contentView = ChangePartyGameView.construct(delegate: controller, dataSource: controller)
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
    
    // MARK: - Navigation Bar Functions
    
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
        self.contentView.startAnimatingSaveButton()

        self.party.change(gameId: self.partyGameId, callback: {
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

extension ChangePartyGameViewController: ChangePartyGameViewDataSource {

    func changePartyGameViewPartyGameId() -> String {
        guard let partyGameId = self.partyGameId else {
            return Partybox.value.none
        }

        return partyGameId
    }

    func changePartyGameViewPartyGamesCount() -> Int {
        return Partybox.collection.games.count
    }

    func changePartyGameViewPartyGame(index: Int) -> PartyGame {
        guard let partyGameId = self.partyGameId, let game = Partybox.collection.games[partyGameId] else {
            return PartyGame()
        }

        return game
    }

}
