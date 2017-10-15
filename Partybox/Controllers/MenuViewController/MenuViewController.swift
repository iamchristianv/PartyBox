//
//  MenuViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/1/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var startPartyButton: UIButton!
    
    @IBOutlet weak var joinPartyButton: UIButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    // MARK: - Configuration
    
    func configureNavigationBar() {
        self.hideNavigationBar()
    }

    // MARK: - IBActions
    
    @IBAction func startPartyButtonPressed() {
        self.showPrePartyController(type: .startParty)
    }
    
    @IBAction func joinPartyButtonPressed() {
        self.showPrePartyController(type: .joinParty)
    }
    
}
