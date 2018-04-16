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
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: CountdownNotification.timeStarted.rawValue, selector: #selector(timeStarted))
        self.startObservingNotification(name: CountdownNotification.timeChanged.rawValue, selector: #selector(timeChanged))
        self.startObservingNotification(name: CountdownNotification.timeEnded.rawValue, selector: #selector(timeEnded))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: CountdownNotification.timeStarted.rawValue)
        self.stopObservingNotification(name: CountdownNotification.timeChanged.rawValue)
        self.stopObservingNotification(name: CountdownNotification.timeEnded.rawValue)
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
    
    @objc func timeStarted() {
        self.contentView.reloadTable()
    }
    
    @objc func timeChanged() {
        self.contentView.reloadTable()
    }
    
    @objc func timeEnded() {
        self.pushVoteWannabeViewController()
    }
    
    // MARK: - Game Functions
    
    func startGame() {
        Countdown.current.start(seconds: 10)
    }

}
