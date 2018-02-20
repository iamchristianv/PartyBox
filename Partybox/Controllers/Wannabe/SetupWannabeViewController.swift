//
//  SetupWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import SwiftyJSON
import UIKit

class SetupWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: SetupWannabeView = SetupWannabeView()
    
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
        self.setNavigationBarTitle("Play Game")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        let name = Notification.Name(GameNotification.detailsChanged.rawValue)
        let selector = #selector(gameDetailsChanged)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func stopObservingChanges() {
        let name = Notification.Name(GameNotification.detailsChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc func gameDetailsChanged() {
        if Game.wannabe.details.isSetup {
            self.navigationController?.pushViewController(StartWannabeViewController(), animated: true)
        }
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate Functions
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playButtonPressed playButton: UIButton) {
        let path = "\(ReferenceKey.packs.rawValue)/\(Game.wannabe.details.id)/default"
        
        Reference.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [[String: Any]] else{ return }
            
            let packJSON = JSON(snapshotJSON)
            Game.wannabe.pack = WannabePack(JSON: packJSON)
            Game.wannabe.details.isSetup = true
            Game.wannabe.details.rounds = 3
            
            let path = "\(ReferenceKey.games.rawValue)"
            Reference.child(path).updateChildValues(Game.json)
        })
    }
    
}
