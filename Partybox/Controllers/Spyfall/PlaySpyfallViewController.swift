//
//  PlaySpyfallViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PlaySpyfallViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: PlaySpyfallView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = PlaySpyfallView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Spyfall")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension PlaySpyfallViewController: PlaySpyfallViewDelegate {
    
    // MARK: - Play Spyfall View Delegate Methods
    
    func playSpyfallView(_ playSpyfallView: PlaySpyfallView, countdownEnded minutes: Int) {
        print("COUNTDOWN ENDED")
    }
    
}
