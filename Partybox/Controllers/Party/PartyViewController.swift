//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: PartyView!
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyDetailsChanged, selector: #selector(partyDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.partyPeopleChanged, selector: #selector(partyPeopleChangedNotificationObserved))
        self.startObservingSessionNotification(.gameDetailsChanged, selector: #selector(gameDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.gamePeopleChanged, selector: #selector(gamePeopleChangedNotificationObserved))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingSessionNotification(.partyDetailsChanged)
        self.stopObservingSessionNotification(.partyPeopleChanged)
        self.stopObservingSessionNotification(.gameDetailsChanged)
        self.stopObservingSessionNotification(.gamePeopleChanged)
    }
    
    override func loadView() {
        self.configureContentView()
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(Party.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    func configureContentView() {
        self.contentView = PartyView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Action Methods
    
    @objc func leaveButtonPressed() {
        self.showAlert(subject: "Hold on ✋", message: "Are you sure you want to leave the party?", action: "Leave", block: {
            if Party.people.count == 1 {
                Party.end()
            }
            
            if Party.people.count > 1 {
                Party.leave()
            }
            
            self.dismissViewController(animated: true, completion: nil)
        })
    }
    
    // MARK: - Navigation Methods
    
    func showSetupWannabeViewController() {
        self.present(UINavigationController(rootViewController: SetupWannabeViewController()), animated: true, completion: nil)
    }
    
    func showStartWannabeViewController() {
        self.present(UINavigationController(rootViewController: StartWannabeViewController()), animated: true, completion: nil)
    }
    
    // MARK: - Notification Methods
        
    @objc func partyDetailsChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        self.setNavigationBarTitle(Party.details.name)
    }
    
    @objc func partyPeopleChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
    }
    
    @objc func gameDetailsChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        if Party.game.details.setup && !Party.game.details.ready {
            self.showStartWannabeViewController()
        }
    }
    
    @objc func gamePeopleChangedNotificationObserved() {
        
    }
    
}

extension PartyViewController: PartyViewDelegate {
    
    // MARK: - Party View Delegate Methods
    
    func partyView(_ partyView: PartyView, startGameButtonPressed startGameButton: UIButton) {
        self.showSetupWannabeViewController()
    }
    
    func partyView(_ partyView: PartyView, changeGameButtonPressed startGameButton: UIButton) {
        
    }
    
}
