//
//  ChangePartyGameViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyGameViewController: UIViewController {

    // MARK: - Properties

    private var store: Store

    private var party: Party

    private var partyGameId: String

    private var delegate: ChangePartyGameViewControllerDelegate

    private var contentView: ChangePartyGameView

    // MARK: - Initialization Functions

    init(store: Store, party: Party, delegate: ChangePartyGameViewControllerDelegate) {
        self.store = store
        self.party = party
        self.partyGameId = party.gameId
        self.delegate = delegate
        self.contentView = ChangePartyGameView(delegate: self, dataSource: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func changePartyGameView(_ view: ChangePartyGameView, gameSelected gameId: String) {
        self.party.gameId = gameId
        self.contentView.reloadTable()
    }

    func changePartyGameView(_ view: ChangePartyGameView, saveButtonPressed: Bool) {
        self.contentView.startAnimatingSaveButton()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.party.id)"

        let values = [
            PartyKey.gameId.rawValue: self.partyGameId
        ] as [String: Any]

        self.party.update(path: path, values: values, callback: {
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
        return self.party.gameId
    }

    func changePartyGameViewPartyGamesCount() -> Int {
        return 1
    }

    func changePartyGameViewPartyGameId(index: Int) -> String {
        if index == 0 {
            return self.store.wannabe.id
        }

        return Partybox.value.none
    }

    func changePartyGameViewPartyGameName(index: Int) -> String {
        if index == 0 {
            return self.store.wannabe.name
        }

        return Partybox.value.none
    }

}
