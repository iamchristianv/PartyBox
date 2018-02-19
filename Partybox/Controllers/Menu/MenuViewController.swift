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
    
    var contentView: MenuView = MenuView()
    
    var authenticationHandle: AuthStateDidChangeListenerHandle!
    
    var motionManager: CMMotionManager = CMMotionManager()
    
    var confettiTimer: Timer!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .default
        self.setupNavigationBar()
        self.startObservingAuthenticationChanges()
        self.startObservingMotionChanges()
        self.startDroppingConfetti()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().signInAnonymously(completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingAuthenticationChanges()
        self.stopObservingMotionChanges()
        self.stopDroppingConfetti()
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.hideNavigationBar()
    }
    
    // MARK: - Authentication Functions
    
    func startObservingAuthenticationChanges() {
        self.authenticationHandle = Auth.auth().addStateDidChangeListener({
            (_, user) in
            
            if user == nil {
                self.contentView.startAnimatingStartPartyButton()
                self.contentView.startAnimatingJoinPartyButton()
                self.contentView.startAnimatingFindPartyButton()
                self.contentView.startAnimatingVisitStoreButton()
            } else {
                self.contentView.stopAnimatingStartPartyButton()
                self.contentView.stopAnimatingJoinPartyButton()
                self.contentView.stopAnimatingFindPartyButton()
                self.contentView.stopAnimatingVisitStoreButton()
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
            
            guard let motion = motion else { return }
            
            self.contentView.updateConfettiGravityDirection(CGVector(dx: motion.gravity.x, dy: 0.2))
        })
    }
    
    func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    func startDroppingConfetti() {
        let target = self.contentView
        let selector = #selector(MenuView.dropConfetti)
        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.2, target: target, selector: selector, userInfo: nil, repeats: true)
    }
    
    func stopDroppingConfetti() {
        self.confettiTimer.invalidate()
    }

}

extension MenuViewController: MenuViewDelegate {
    
    // MARK: - Menu View Delegate Functions
    
    func menuView(_ menuView: MenuView, startPartyButtonPressed: Bool) {
        self.showStartPartyViewController()
    }
    
    func menuView(_ menuView: MenuView, joinPartyButtonPressed: Bool) {
        self.showJoinPartyViewController()
    }
    
    func menuView(_ menuView: MenuView, findPartyButtonPressed: Bool) {
        self.showFindPartyViewController()
    }
    
    func menuView(_ menuView: MenuView, visitStoreButtonPressed: Bool) {
        self.showStoreViewController()
    }
    
}
