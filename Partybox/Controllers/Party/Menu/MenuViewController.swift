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

    // MARK: - Construction Functions

    static func construct() -> MenuViewController {
        let controller = MenuViewController()
        controller.contentView = MenuView.construct(delegate: controller)
        controller.authenticationHandle = nil
        controller.motionManager = CMMotionManager()
        controller.confettiTimer = nil
        return controller
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
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
        self.hideNavigationBar()
    }
    
    // MARK: - Authentication Functions
    
    private func startObservingAuthenticationChanges() {
        self.authenticationHandle = Auth.auth().addStateDidChangeListener({
            (auth, user) in
            
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
    
    private func stopObservingAuthenticationChanges() {
        Auth.auth().removeStateDidChangeListener(self.authenticationHandle)
    }
    
    // MARK: - Motion Functions
    
    private func startObservingMotionChanges() {
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, error) in

            guard let motion = motion else {
                return
            }

            let direction = CGVector(dx: motion.gravity.x, dy: 0.2)
            self.contentView.setConfettiGravityDirection(direction)
        })
    }
    
    private func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    private func startDroppingConfetti() {
        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                  target: self.contentView,
                                                  selector: #selector(MenuView.dropConfetti),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    private func stopDroppingConfetti() {
        self.confettiTimer.invalidate()
    }

}

extension MenuViewController: MenuViewDelegate {
        
    internal func menuView(_ menuView: MenuView, startPartyButtonPressed: Bool) {
        let startPartyViewController = StartPartyViewController.construct()
        let navigationController = UINavigationController(rootViewController: startPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func menuView(_ menuView: MenuView, joinPartyButtonPressed: Bool) {
        let joinPartyViewController = JoinPartyViewController.construct()
        let navigationController = UINavigationController(rootViewController: joinPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    internal func menuView(_ menuView: MenuView, findPartyButtonPressed: Bool) {

    }

    internal func menuView(_ menuView: MenuView, visitStoreButtonPressed: Bool) {

    }
    
}
