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
    
    private var contentView: MenuView!
    
    private var authenticationHandle: AuthStateDidChangeListenerHandle!
    
    private var motionManager: CMMotionManager!
    
    private var confettiTimer: Timer!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = MenuView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
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
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .default
        self.edgesForExtendedLayout = []
    }
    
    private func setupNavigationBar() {
        self.hideNavigationBar()
    }
    
    // MARK: - Authentication Functions
    
    private func startObservingAuthenticationChanges() {
        self.authenticationHandle = Auth.auth().addStateDidChangeListener({
            (auth, user) in
            
            if user == nil {
                self.contentView.startAnimatingStartPartyButton()
                self.contentView.startAnimatingJoinPartyButton()
            } else {
                self.contentView.stopAnimatingStartPartyButton()
                self.contentView.stopAnimatingJoinPartyButton()
            }
        })
    }
    
    private func stopObservingAuthenticationChanges() {
        Auth.auth().removeStateDidChangeListener(self.authenticationHandle)
    }
    
    // MARK: - Motion Functions
    
    private func startObservingMotionChanges() {
        self.motionManager = CMMotionManager()

        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, error) in

            guard let motion = motion else {
                return
            }
            
            self.contentView.updateConfettiGravityDirection(CGVector(dx: motion.gravity.x, dy: 0.2))
        })
    }
    
    private func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    private func startDroppingConfetti() {
        self.confettiTimer = Timer()

        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                  target: self,
                                                  selector: #selector(dropConfetti),
                                                  userInfo: nil,
                                                  repeats: true)
    }

    @objc private func dropConfetti() {
        self.contentView.dropConfetti()
    }
    
    private func stopDroppingConfetti() {        
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
    
}
