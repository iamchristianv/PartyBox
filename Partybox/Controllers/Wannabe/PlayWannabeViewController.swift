//
//  PlayWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PlayWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: PlayWannabeView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyDetailsChanged, selector: #selector(partyDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.partyPeopleChanged, selector: #selector(partyPeopleChangedNotificationObserved))
        self.startObservingSessionNotification(.gameDetailsChanged, selector: #selector(gameDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.gamePeopleChanged, selector: #selector(gamePeopleChangedNotificationObserved))
        
        if Party.userHost {
            Party.game.details.card = Party.game.pack.randomCard()
            Party.synchronize()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingSessionNotification(.partyDetailsChanged)
        self.stopObservingSessionNotification(.partyPeopleChanged)
        self.stopObservingSessionNotification(.gameDetailsChanged)
        self.stopObservingSessionNotification(.gamePeopleChanged)
    }
    
    override func loadView() {
        self.contentView = PlayWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Wannabe")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    func showVoteWannabeViewController() {
        self.navigationController?.pushViewController(VoteWannabeViewController(), animated: true)
    }
    
    // MARK: - Notification Methods
    
    @objc func partyDetailsChangedNotificationObserved() {
        
    }
    
    @objc func partyPeopleChangedNotificationObserved() {
        
    }
    
    @objc func gameDetailsChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        if !Party.game.details.card.content.isEmpty && !Party.game.details.card.type.isEmpty {
            Party.startCountdown(seconds: Party.game.details.roundLength)
        }
    }
    
    @objc func gamePeopleChangedNotificationObserved() {
        
    }

}

extension PlayWannabeViewController: PlayWannabeViewDelegate {
    
    // MARK: - Play Wannabe View Delegate Methods
    
    func playWannabeView(_ playWannabeView: PlayWannabeView, countdownEnded minutes: Int) {
        self.showVoteWannabeViewController()
    }
    
}
