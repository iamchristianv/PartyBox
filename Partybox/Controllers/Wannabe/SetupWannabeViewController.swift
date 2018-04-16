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
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = SetupWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: GameNotification.detailsChanged.rawValue, selector: #selector(gameDetailsChanged))
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
        if Wannabe.current.details.isSetup {
            self.pushStartWannabeViewController()
        }
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate Functions
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()
        
        Wannabe.current.loadPack(id: self.contentView.selectedPackValue().id, callback: {
            (error) in
            
            Wannabe.current.details.isSetup = true
            Wannabe.current.details.rounds = self.contentView.selectedRoundsValue().rawValue
            
            let path = "\(DatabaseKey.games.rawValue)"
            let value = Wannabe.current.json
            
            Database.current.child(path).updateChildValues(value, withCompletionBlock: {
                (error, reference) in
                
                self.contentView.stopAnimatingPlayButton()
            })
        })
    }
    
}
