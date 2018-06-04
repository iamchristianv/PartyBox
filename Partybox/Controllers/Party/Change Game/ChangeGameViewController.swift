//
//  ChangeGameViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeGameViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!
    
    private var contentView: ChangeGameView!

    private var delegate: ChangeGameViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: ChangeGameViewControllerDelegate) -> ChangeGameViewController {
        let controller = ChangeGameViewController()
        controller.session = session
        controller.contentView = ChangeGameView.construct(delegate: controller, dataSource: controller)
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
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }
    
    // MARK: - Action Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChangeGameViewController: ChangeGameViewDelegate {

    func changeGameView(_ changeGameView: ChangeGameView, saveButtonPressed: Bool) {
        if self.contentView.gameId() == self.session.party.details.gameId {
            let subject = "Woah there"
            let message = "Please select a new game"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            self.contentView.startAnimatingSaveButton()

            let values = [PartyDetailsKey.gameId.rawValue: self.contentView.gameId()]

            self.session.party.details.update(values: values, callback: {
                (error) in

                self.contentView.stopAnimatingSaveButton()

                if let error = error {
                    let subject = "Oh no"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                } else {
                    self.delegate.changeGameViewController(self, gameChanged: true)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
}

extension ChangeGameViewController: ChangeGameViewDataSource {

    func changeGameViewGameId() -> String {
        return self.session.party.details.gameId
    }

    func changeGameViewGameCount() -> Int {
        return self.session.games.count
    }

    func changeGameViewGameId(index: Int) -> String {
        let game = self.session.games[index]

        if game is Wannabe {
            return self.session.wannabe.details.id
        }

        return Partybox.values.none
    }

    func changeGameViewGameName(index: Int) -> String {
        let game = self.session.games[index]

        if game is Wannabe {
            return self.session.wannabe.details.name
        }

        return Partybox.values.none
    }

}
