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
    
    // MARK: - Model Properties

    private var store: Store!

    // MARK: - View Properties
    
    private var contentView: MenuView!

    // MARK: - Controller Properties

    private var authenticationHandle: AuthStateDidChangeListenerHandle!
    
    private var motionManager: CMMotionManager!
    
    private var confettiTimer: Timer!

    // MARK: - Construction Functions

    static func construct() -> MenuViewController {
        let controller = MenuViewController()
        controller.store = Store.construct()
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
        Partybox.firebase.authenticator.signInAnonymously(completion: nil)
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
        self.authenticationHandle = Partybox.firebase.authenticator.addStateDidChangeListener({
            (auth, user) in
            
            if user == nil {
                self.contentView.startAnimatingStartPartyButton()
                self.contentView.startAnimatingJoinPartyButton()
                self.contentView.startAnimatingMoreButton()
            } else {
                self.contentView.stopAnimatingStartPartyButton()
                self.contentView.stopAnimatingJoinPartyButton()
                self.contentView.stopAnimatingMoreButton()
            }
        })
    }
    
    private func stopObservingAuthenticationChanges() {
        Partybox.firebase.authenticator.removeStateDidChangeListener(self.authenticationHandle)
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
        
    internal func menuView(_ view: MenuView, startPartyButtonPressed: Bool) {
        let rootViewController = StartPartyViewController.construct(store: self.store)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func menuView(_ view: MenuView, joinPartyButtonPressed: Bool) {
        let rootViewController = JoinPartyViewController.construct(store: self.store)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    internal func menuView(_ view: MenuView, moreButtonPressed: Bool) {

    }
    
}
