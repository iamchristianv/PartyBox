//
//  MenuView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    // MARK: - Instance Properties
    
    private lazy var partyboxImageView: UIImageView = {
        let partyboxImageView = UIImageView()
        partyboxImageView.image = UIImage(named: "Partybox")
        return partyboxImageView
    }()
    
    private lazy var startPartyButton: ActivityIndicatorButton = {
        let startPartyButton = ActivityIndicatorButton()
        startPartyButton.setTitle("Start Party", for: .normal)
        startPartyButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        startPartyButton.setTitleColor(Partybox.colors.white, for: .normal)
        startPartyButton.setBackgroundColor(Partybox.colors.red)
        startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
        return startPartyButton
    }()
    
    private lazy var joinPartyButton: ActivityIndicatorButton = {
        let joinPartyButton = ActivityIndicatorButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        joinPartyButton.setTitleColor(Partybox.colors.white, for: .normal)
        joinPartyButton.setBackgroundColor(Partybox.colors.blue)
        joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        return joinPartyButton
    }()

    private lazy var findPartyButton: ActivityIndicatorButton = {
        let findPartyButton = ActivityIndicatorButton()
        findPartyButton.setTitle("Find Party", for: .normal)
        findPartyButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        findPartyButton.setTitleColor(Partybox.colors.white, for: .normal)
        findPartyButton.setBackgroundColor(Partybox.colors.purple)
        findPartyButton.addTarget(self, action: #selector(findPartyButtonPressed), for: .touchUpInside)
        return findPartyButton
    }()

    private lazy var visitStoreButton: ActivityIndicatorButton = {
        let visitStoreButton = ActivityIndicatorButton()
        visitStoreButton.setTitle("Visit Store", for: .normal)
        visitStoreButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        visitStoreButton.setTitleColor(Partybox.colors.white, for: .normal)
        visitStoreButton.setBackgroundColor(Partybox.colors.green)
        visitStoreButton.addTarget(self, action: #selector(visitStoreButtonPressed), for: .touchUpInside)
        return visitStoreButton
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.addBehavior(self.gravityBehavior)
        animator.addBehavior(self.extraLightConfettiBehavior)
        animator.addBehavior(self.lightConfettiBehavior)
        animator.addBehavior(self.normalConfettiBehavior)
        animator.addBehavior(self.heavyConfettiBehavior)
        animator.addBehavior(self.extraHeavyConfettiBehavior)
        return animator
    }()
    
    private lazy var gravityBehavior: UIGravityBehavior = {
        let gravityBehavior = UIGravityBehavior()
        return gravityBehavior
    }()
    
    private lazy var extraLightConfettiBehavior: UIDynamicItemBehavior = {
        let extraLightConfettiBehavior = UIDynamicItemBehavior()
        extraLightConfettiBehavior.allowsRotation = true
        extraLightConfettiBehavior.resistance = 6.0
        return extraLightConfettiBehavior
    }()
    
    private lazy var lightConfettiBehavior: UIDynamicItemBehavior = {
        let lightConfettiBehavior = UIDynamicItemBehavior()
        lightConfettiBehavior.allowsRotation = true
        lightConfettiBehavior.resistance = 5.5
        return lightConfettiBehavior
    }()
    
    private lazy var normalConfettiBehavior: UIDynamicItemBehavior = {
        let normalConfettiBehavior = UIDynamicItemBehavior()
        normalConfettiBehavior.allowsRotation = true
        normalConfettiBehavior.resistance = 5.0
        return normalConfettiBehavior
    }()
    
    private lazy var heavyConfettiBehavior: UIDynamicItemBehavior = {
        let heavyConfettiBehavior = UIDynamicItemBehavior()
        heavyConfettiBehavior.allowsRotation = true
        heavyConfettiBehavior.resistance = 4.5
        return heavyConfettiBehavior
    }()
    
    private lazy var extraHeavyConfettiBehavior: UIDynamicItemBehavior = {
        let extraHeavyConfettiBehavior = UIDynamicItemBehavior()
        extraHeavyConfettiBehavior.allowsRotation = true
        extraHeavyConfettiBehavior.resistance = 4.0
        return extraHeavyConfettiBehavior
    }()
    
    private var delegate: MenuViewDelegate!

    // MARK: - Constructor Functions

    static func construct(delegate: MenuViewDelegate) -> MenuView {
        let view = MenuView()
        view.delegate = delegate
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.partyboxImageView)
        self.addSubview(self.startPartyButton)
        self.addSubview(self.joinPartyButton)
        self.addSubview(self.findPartyButton)
        self.addSubview(self.visitStoreButton)
        
        self.partyboxImageView.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(100)
        })
        
        self.startPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.partyboxImageView.snp.bottom).offset(40)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(20)
        })

        self.findPartyButton.snp.remakeConstraints({
            (make) in

            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.joinPartyButton.snp.bottom).offset(20)
        })

        self.visitStoreButton.snp.remakeConstraints({
            (make) in

            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions
    
    @objc private func startPartyButtonPressed() {
        self.delegate.menuView(self, startPartyButtonPressed: true)
    }
    
    @objc private func joinPartyButtonPressed() {
        self.delegate.menuView(self, joinPartyButtonPressed: true)
    }

    @objc private func findPartyButtonPressed() {
        self.delegate.menuView(self, findPartyButtonPressed: true)
    }

    @objc private func visitStoreButtonPressed() {
        self.delegate.menuView(self, visitStoreButtonPressed: true)
    }
    
    // MARK: - Animation Functions
    
    func startAnimatingStartPartyButton() {
        self.startPartyButton.startAnimating()
    }
    
    func stopAnimatingStartPartyButton() {
        self.startPartyButton.stopAnimating()
    }
    
    func startAnimatingJoinPartyButton() {
        self.joinPartyButton.startAnimating()
    }
    
    func stopAnimatingJoinPartyButton() {
        self.joinPartyButton.stopAnimating()
    }

    func startAnimatingFindPartyButton() {
        self.findPartyButton.startAnimating()
    }

    func stopAnimatingFindPartyButton() {
        self.findPartyButton.stopAnimating()
    }

    func startAnimatingVisitStoreButton() {
        self.visitStoreButton.startAnimating()
    }

    func stopAnimatingVisitStoreButton() {
        self.visitStoreButton.stopAnimating()
    }

    func setConfettiGravityDirection(_ direction: CGVector) {
        self.gravityBehavior.gravityDirection = direction
    }
        
    @objc func dropConfetti() {
        var confetti: ShapeView!
        
        let shapes = [SquareView.self, TriangleView.self, CircleView.self]
        let randomShape = shapes[Int(arc4random()) % shapes.count]
        
        let randomSize = Int(arc4random_uniform(5) + 10)
        let randomFrame = CGRect(x: Int(arc4random()) % Int(self.frame.size.width),
                                 y: -randomSize,
                                 width: randomSize,
                                 height: randomSize)
        
        let colors = [Partybox.colors.red, Partybox.colors.blue, Partybox.colors.green, Partybox.colors.purple]
        let randomColor = colors[Int(arc4random()) % colors.count]
        
        if randomShape == SquareView.self {
            confetti = SquareView(frame: randomFrame, color: randomColor)
        } else if randomShape == TriangleView.self {
            confetti = TriangleView(frame: randomFrame, color: randomColor)
        } else if randomShape == CircleView.self {
            confetti = CircleView(frame: randomFrame, color: randomColor)
        }
        
        self.animator.referenceView?.insertSubview(confetti, at: 0)
        self.gravityBehavior.addItem(confetti)
        
        let randomSpeed = CGFloat(arc4random_uniform(4) + 2)
        let randomDirection = CGFloat(arc4random_uniform(2))
        let randomAngularVelocity = randomDirection == 0 ? randomSpeed : -randomSpeed
        
        let randomResistance = arc4random_uniform(5)
        
        if randomResistance == 0 {
            self.extraLightConfettiBehavior.addItem(confetti)
            self.extraLightConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        } else if randomResistance == 1 {
            self.lightConfettiBehavior.addItem(confetti)
            self.lightConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        } else if randomResistance == 2 {
            self.normalConfettiBehavior.addItem(confetti)
            self.normalConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        } else if randomResistance == 3 {
            self.heavyConfettiBehavior.addItem(confetti)
            self.heavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        } else if randomResistance == 4 {
            self.extraHeavyConfettiBehavior.addItem(confetti)
            self.extraHeavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        }
    }
    
}