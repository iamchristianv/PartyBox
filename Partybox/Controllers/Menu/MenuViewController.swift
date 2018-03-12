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
    
    override func loadView() {
        self.contentView = MenuView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motionManager = CMMotionManager()
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
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .default
        self.edgesForExtendedLayout = []
    }
    
    func setupNavigationBar() {
        self.hideNavigationBar()
    }
    
    // MARK: - Authentication Functions
    
    func startObservingAuthenticationChanges() {
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
    
    func stopObservingAuthenticationChanges() {
        Auth.auth().removeStateDidChangeListener(self.authenticationHandle)
    }
    
    // MARK: - Motion Functions
    
    func startObservingMotionChanges() {
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, error) in

            guard let motion = motion else { return }
            
            self.contentView.updateConfettiGravityDirection(CGVector(dx: motion.gravity.x, dy: 0.2))
        })
    }
    
    func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    func startDroppingConfetti() {
        let target = self.contentView!
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
    
}
