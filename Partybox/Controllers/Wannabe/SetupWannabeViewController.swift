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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {
    
    // MARK: - Setup Wannabe View Delegate Functions
    
    func setupWannabeView(_ setupWannabeView: SetupWannabeView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()
        
        Wannabe.current.loadPack(id: self.contentView.selectedPackValue().id, callback: {
            (error) in
            
            self.contentView.stopAnimatingPlayButton()
            
            Wannabe.current.details.isSetup = true
            Wannabe.current.details.rounds = self.contentView.selectedRoundsValue().rawValue
            
            Reference.current.startGame(callback: {
                (error) in
                
                if let error = error {
                    self.showErrorAlert(error: error)
                } else {
                    self.pushStartWannabeViewController()
                }
            })
        })
    }
    
}
