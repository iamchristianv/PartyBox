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
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = PlayWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: GameNotification.detailsChanged.rawValue, selector: #selector(gameDetailsChanged))
        
        if User.current.name == Party.current.details.hostName {
            //Session.game.details.card = Party.game.pack.randomCard()
            //Session.synchronize()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: GameNotification.detailsChanged.rawValue)
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Wannabe")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
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
