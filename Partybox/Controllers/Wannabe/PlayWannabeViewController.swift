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
    
    var contentView: PlayWannabeView = PlayWannabeView()
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupStatusBar()
        self.setupNavigationBar()
        self.startObservingChanges()
        
        if User.current.name == Party.current.details.hostName {
            //Session.game.details.card = Party.game.pack.randomCard()
            //Session.synchronize()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingChanges()
    }
    
    // MARK: - Setup Functions
    
    func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Wannabe")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarRightButton(title: "hint", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        let name = Notification.Name(ReferenceNotification.gameDetailsChanged.rawValue)
        let selector = #selector(gameDetailsChanged)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func stopObservingChanges() {
        let name = Notification.Name(ReferenceNotification.partyPeopleChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc func gameDetailsChanged() {
        self.contentView.tableView.reloadData()
        
//        if !game.wannabe.details.card.content.isEmpty && !game.wannabe.details.card.type.isEmpty {
//            //Party.startCountdown(seconds: Party.game.details.roundLength)
//        }
    }

}

extension PlayWannabeViewController: PlayWannabeViewDelegate {
    
    // MARK: - Play Wannabe View Delegate Functions
    
    func playWannabeView(_ playWannabeView: PlayWannabeView, countdownEnded minutes: Int) {
        self.navigationController?.pushViewController(VoteWannabeViewController(), animated: true)
    }
    
}
