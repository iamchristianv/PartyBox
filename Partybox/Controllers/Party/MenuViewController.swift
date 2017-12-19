//
//  MenuViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // MARK: - Instance Properties
    
    var contentView: MenuView! {
        didSet {
            self.contentView.startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
            self.contentView.joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        }
    }
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = MenuView()
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.hideNavigationBar()
    }
    
    // MARK: - Navigation Methods
    
    @objc func startPartyButtonPressed() {
        self.showStartPartyViewController()
    }
    
    @objc func joinPartyButtonPressed() {
        self.showJoinPartyViewController()
    }

}
