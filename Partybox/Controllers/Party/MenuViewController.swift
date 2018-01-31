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
    
    var motionManager: CMMotionManager!
    
    var confettiTimer: Timer!
    
    // MARK: - View Controller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.setupMotionManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupStatusBar()
        self.setupNavigationBar()
        self.startObservingAuthenticationChanges()
        self.startObservingMotionChanges()
        self.startDroppingConfetti()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().signInAnonymously(completion: nil)
        // load Partybox configurations
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingAuthenticationChanges()
        self.stopObservingMotionChanges()
        self.stopDroppingConfetti()
    }
    
    override func loadView() {
        self.setupContentView()
    }
    
    // MARK: - Setup Functions
    
    func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupNavigationBar() {
        self.hideNavigationBar()
    }
    
    func setupContentView() {
        self.contentView = MenuView()
        self.contentView.startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
        self.contentView.joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        self.contentView.findPartyButton.addTarget(self, action: #selector(findPartyButtonPressed), for: .touchUpInside)
        self.contentView.visitStoreButton.addTarget(self, action: #selector(visitStoreButtonPressed), for: .touchUpInside)
        self.view = self.contentView
    }
    
    func setupMotionManager() {
        self.motionManager = CMMotionManager()
    }
    
    // MARK: - Action Functions
    
    @objc func startPartyButtonPressed() {
        self.showStartPartyViewController()
    }
    
    @objc func joinPartyButtonPressed() {
        self.showJoinPartyViewController()
    }
    
    @objc func findPartyButtonPressed() {
        self.showFindPartyViewController()
    }
    
    @objc func visitStoreButtonPressed() {
        self.showStoreViewController()
    }

    // MARK: - Navigation Functions
    
    func showStartPartyViewController() {
        self.present(UINavigationController(rootViewController: StartPartyViewController()), animated: true, completion: nil)
    }
    
    func showJoinPartyViewController() {
        self.present(UINavigationController(rootViewController: JoinPartyViewController()), animated: true, completion: nil)
    }
    
    func showFindPartyViewController() {
        
    }
    
    func showStoreViewController() {
        
    }
    
    // MARK: - Authentication Functions
    
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
    
    // MARK: - Motion Functions
    
    func startObservingMotionChanges() {
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, _) in
            
            self.contentView.updateConfettiGravityDirection(CGVector(dx: motion!.gravity.x, dy: 0.2))
        })
    }
    
    func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    func startDroppingConfetti() {
        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                  target: self.contentView,
                                                  selector: #selector(MenuView.dropConfetti),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    func stopDroppingConfetti() {
        self.confettiTimer.invalidate()
    }

}
