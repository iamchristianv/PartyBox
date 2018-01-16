//
//  MenuViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import CoreMotion
import Firebase
import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var contentView: MenuView!
    
    var authenticationHandle: AuthStateDidChangeListenerHandle!
    
    var confettiTimer: Timer!
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureStatusBar()
        self.configureNavigationBar()
        self.startObservingAuthenticationChanges()
        self.startDroppingConfetti()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingAuthenticationChanges()
        self.stopDroppingConfetti()
    }
    
    override func loadView() {
        self.configureContentView()
    }
    
    // MARK: - Configuration Methods
    
    func configureStatusBar() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func configureNavigationBar() {
        self.hideNavigationBar()
    }
    
    func configureContentView() {
        self.contentView = MenuView()
        self.contentView.startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
        self.contentView.joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        self.view = self.contentView
    }
    
    // MARK: - Action Methods
    
    @objc func startPartyButtonPressed() {
        self.showStartPartyViewController()
    }
    
    @objc func joinPartyButtonPressed() {
        self.showJoinPartyViewController()
    }

    // MARK: - Navigation Methods
    
    func showStartPartyViewController() {
        self.present(UINavigationController(rootViewController: StartPartyViewController()), animated: true, completion: nil)
    }
    
    func showJoinPartyViewController() {
        self.present(UINavigationController(rootViewController: JoinPartyViewController()), animated: true, completion: nil)
    }
    
    // MARK: - Authentication Methods
    
    func startObservingAuthenticationChanges() {
        self.authenticationHandle = Auth.auth().addStateDidChangeListener({
            (_, user) in
            
            if user == nil {
                self.contentView.startAnimatingStartPartyButton()
                self.contentView.startAnimatingJoinPartyButton()
            }
            else {
                self.contentView.stopAnimatingStartPartyButton()
                self.contentView.stopAnimatingJoinPartyButton()
            }
        })
    }
    
    func stopObservingAuthenticationChanges() {
        Auth.auth().removeStateDidChangeListener(self.authenticationHandle)
    }
    
    // MARK: - Confetti Methods
    
    func startDroppingConfetti() {
        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.25,
                                                  target: self,
                                                  selector: #selector(dropConfettiPiece),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    func stopDroppingConfetti() {
        self.confettiTimer.invalidate()
    }
    
    @objc func dropConfettiPiece() {
        self.contentView.dropConfettiPiece()
    }

}
