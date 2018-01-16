//
//  SetupWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import SwiftyJSON
import UIKit

class SetupWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: SetupWannabeView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyDetailsChanged, selector: #selector(partyDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.partyPeopleChanged, selector: #selector(partyPeopleChangedNotificationObserved))
        self.startObservingSessionNotification(.gameDetailsChanged, selector: #selector(gameDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.gamePeopleChanged, selector: #selector(gamePeopleChangedNotificationObserved))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingSessionNotification(.partyDetailsChanged)
        self.stopObservingSessionNotification(.partyPeopleChanged)
        self.stopObservingSessionNotification(.gameDetailsChanged)
        self.stopObservingSessionNotification(.gamePeopleChanged)
    }
    
    override func loadView() {
        self.contentView = SetupWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Setup Wannabe")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    func showStartWannabeViewController() {
        self.navigationController?.pushViewController(StartWannabeViewController(), animated: true)
    }
    
    // MARK: - Notification Methods
    
    @objc func partyDetailsChangedNotificationObserved() {
        
    }
    
    @objc func partyPeopleChangedNotificationObserved() {
        
    }
    
    @objc func gameDetailsChangedNotificationObserved() {
        if Party.game.details.setup {
            self.showStartWannabeViewController()
        }
    }
    
    @objc func gamePeopleChangedNotificationObserved() {
        
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playGameButtonPressed button: UIButton) {
        Database.database().reference().child("packs/\(Party.game.details.id)/default").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [[String: Any]] else{
                return
            }
            
            let packJSON = JSON(snapshotJSON)
            
            Party.game.details.rounds = 3
            Party.game.details.setup = true
            Party.game.pack = WannabePack(JSON: packJSON)
            Party.synchronize()
        })
    }
    
}
