//
//  EndWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import SwiftyJSON
import UIKit

class EndWannabeViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var contentView: EndWannabeView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func loadView() {
        self.contentView = EndWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Game Over")
        self.setNavigationBarLeftButton(title: "", target: self, action: #selector(dummy))
    }
    
    @objc func dummy() {
        
    }

}

extension EndWannabeViewController: EndWannabeViewDelegate {
    
    // MARK: - End Wannabe View Delegate Methods
    
    func endWannabeView(_ endWannabeView: EndWannabeView, backToPartyButtonPressed button: UIButton) {
        if Party.userHost {
            Party.game = WannabeGame(JSON: JSON(""))
            Party.synchronize()
        }
        
        self.dismissViewController(animated: true, completion: nil)
    }
    
}
