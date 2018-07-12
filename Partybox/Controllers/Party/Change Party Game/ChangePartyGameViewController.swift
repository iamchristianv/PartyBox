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

    private var partyGame: PartyGame!

    private var delegate: ChangePartyGameViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyGameViewControllerDelegate) -> ChangePartyGameViewController {
        let controller = ChangePartyGameViewController()
        controller.store = store
        controller.party = party
        controller.contentView = ChangePartyGameView.construct(delegate: controller, dataSource: controller)
        controller.partyGame = party.game
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

    func changePartyGameView(_ view: ChangePartyGameView, gameChanged game: PartyGame) {
        self.party.game = game
        self.contentView.reloadTable()
    }

    func changePartyGameView(_ view: ChangePartyGameView, saveButtonPressed: Bool) {
        if self.partyGame == self.party.game {
            let subject = "Woah there"
            let message = "Please select a new game"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            return
        }

        self.contentView.startAnimatingSaveButton()

        if let wannabe = self.partyGame as? Wannabe {
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

    func changePartyGameViewPartyGame() -> PartyGame {
        return self.partyGame
    }

    func changePartyGameViewPartyGamesCount() -> Int {
        return self.party.games.count
    }

    func changePartyGameViewPartyGame(index: Int) -> PartyGame? {
        return self.party.games[index]
    }

}
