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
    
    var contentView: EndWannabeView = EndWannabeView()
    
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
        self.setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Setup Functions
    
    func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Game Over")
        self.setNavigationBarLeftButton(title: "", target: self, action: #selector(dummy))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    @objc func dummy() {
        
    }

}

extension EndWannabeViewController: EndWannabeViewDelegate {
    
    // MARK: - End Wannabe View Delegate Methods
    
    func endWannabeView(_ endWannabeView: EndWannabeView, backToPartyButtonPressed button: UIButton) {
        if User.current.name == Party.current.details.hostName {
            //Session.game = WannabeGame(JSON: JSON(""))
            //Party.synchronize()
        }
        
        self.dismissViewController(animated: true, completion: nil)
    }
    
}
