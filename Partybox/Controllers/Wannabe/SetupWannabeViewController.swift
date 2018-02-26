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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.startObservingGameDetailsChanges(selector: #selector(gameDetailsChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingGameDetailsChanges()
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Play Game")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc func gameDetailsChanged() {
        if Game.current.wannabe.details.isSetup {
            self.pushStartWannabeViewController()
        }
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate Functions
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playButtonPressed: Bool) {
        let path = "\(ReferenceKey.packs.rawValue)/\(Game.current.wannabe.details.id)/default"
        
        self.contentView.startAnimatingPlayButton()
        
        Reference.current.database.child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            self.contentView.stopAnimatingPlayButton()
            
            guard let snapshotJSON = snapshot.value as? [[String: Any]] else{ return }
            
            let packJSON = JSON(snapshotJSON)
            Game.current.wannabe.pack = WannabePack(JSON: packJSON)
            Game.current.wannabe.details.isSetup = true
            Game.current.wannabe.details.rounds = 3
            
            let path = "\(ReferenceKey.games.rawValue)"
            Reference.current.database.child(path).updateChildValues(Game.current.json)
        })
    }
    
}
