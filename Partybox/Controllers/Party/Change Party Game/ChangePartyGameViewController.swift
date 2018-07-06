//
//  ChangePartyGameViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyGameViewController: UIViewController {

    // MARK: - Instance Properties

    private var store: Store!

    private var party: Party!
    
    private var contentView: ChangePartyGameView!

    private var delegate: ChangePartyGameViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyGameViewControllerDelegate) -> ChangePartyGameViewController {
        let controller = ChangePartyGameViewController()
        controller.store = store
        controller.party = party
        controller.contentView = ChangePartyGameView.construct(delegate: controller, dataSource: controller)
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

    func changePartyGameView(_ view: ChangePartyGameView, saveButtonPressed: Bool) {
        if self.contentView.partyGameName() == self.party.gameName {
            let subject = "Woah there"
            let message = "Please select a new game"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            return
        }

        self.contentView.startAnimatingSaveButton()

        self.party.change(gameName: self.contentView.partyGameName(), callback: {
            (error) in

            self.contentView.stopAnimatingSaveButton()

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.delegate.changePartyGameViewController(self, partyGameChanged: true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

extension ChangePartyGameViewController: ChangePartyGameViewDataSource {

    func changePartyGameViewPartyGameName() -> String {
        return self.party.gameName
    }

    func changePartyGameViewPartyGameCount() -> Int {
        return 1
    }

    func changePartyGameViewPartyGameName(index: Int) -> String {
        return "Wannabe"
    }

}
