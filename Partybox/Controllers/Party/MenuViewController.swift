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
    
    var confettiPieceTimer: Timer!
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.configureMotionManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureStatusBar()
        self.configureNavigationBar()
        self.startObservingAuthenticationChanges()
        self.startObservingMotionChanges()
        self.startDroppingConfettiPieces()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingAuthenticationChanges()
        self.stopObservingMotionChanges()
        self.stopDroppingConfettiPieces()
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
    
    func configureMotionManager() {
        self.motionManager = CMMotionManager()
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
    
    // MARK: - Motion Methods
    
    func startObservingMotionChanges() {
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, _) in
            
            guard let motion = motion else {
                return
            }
            
            self.contentView.updateConfettiPieceGravityDirection(CGVector(dx: motion.gravity.x, dy: 0.2))
        })
    }
    
    func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Methods
    
    func startDroppingConfettiPieces() {
        self.confettiPieceTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                  target: self,
                                                  selector: #selector(dropConfettiPiece),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    func stopDroppingConfettiPieces() {
        self.confettiPieceTimer.invalidate()
    }
    
    @objc func dropConfettiPiece() {
        self.contentView.dropConfettiPiece()
    }

}
