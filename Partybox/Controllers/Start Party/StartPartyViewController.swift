//
//  StartPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    private var contentView: StartPartyView!

    // MARK: - Construction Functions

    static func construct() -> StartPartyViewController {
        let controller = StartPartyViewController()
        controller.contentView = StartPartyView.construct(delegate: controller)
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
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.red)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension StartPartyViewController: StartPartyViewDelegate {
    
    // MARK: - Start Party View Delegate Functions
    
    internal func startPartyView(_ startPartyView: StartPartyView, startButtonPressed: Bool) {
        self.contentView.startAnimatingStartButton()

        let partyName = self.contentView.partyName()
        let userName = self.contentView.userName()

        let user = User.construct(name: userName)
        let party = Party.construct(name: partyName)
        let game = Game.construct(party: party.details.id)

        party.start(user: user, callback: {
            (error) in

            self.contentView.stopAnimatingStartButton()

            if let error = error {
                let subject = "Uh oh"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                let partyViewController = PartyViewController.construct(user: user, party: party, game: game, delegate: self)
                let navigationController = UINavigationController(rootViewController: partyViewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }

}

extension StartPartyViewController: PartyViewControllerDelegate {

    // MARK: - Party View Controller Delegate Functions

    internal func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        let subject = "Oh no"
        let message = "You were kicked from the party"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }

}

