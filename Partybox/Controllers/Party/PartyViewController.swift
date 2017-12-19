//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: PartyView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyChanged, selector: #selector(partyChangedNotificationObserved))
        self.startObservingSessionNotification(.gameChanged, selector: #selector(gameChangedNotificationObserved))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingSessionNotification(.partyChanged)
        self.stopObservingSessionNotification(.gameChanged)
    }
    
    override func loadView() {
        self.contentView = PartyView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(Session.party.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: {
            if Session.party.people.count == 1 {
                Session.end()
            }
            
            if Session.party.people.count > 1 {
                Session.leave()
            }
        })
    }
    
    // MARK: - Notification Methods
        
    @objc func partyChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        self.setNavigationBarTitle(Session.party.details.name)
    }
    
    @objc func gameChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        if Session.game.details.setup && !Session.game.details.ready {
            self.showStartSpyfallViewController()
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {
    
    // MARK: - Party View Delegate Methods
    
    func partyView(_ partyView: PartyView, startGameButtonPressed startGameButton: UIButton) {
        self.showSetupSpyfallViewController()
    }
    
    func partyView(_ partyView: PartyView, changeGameButtonPressed startGameButton: UIButton) {
        
    }
    
}
