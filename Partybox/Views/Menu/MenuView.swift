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
        startPartyButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        startPartyButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        startPartyButton.setBackgroundColor(UIColor.Partybox.red)
        startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
        return startPartyButton
    }()
    
    private lazy var joinPartyButton: ActivityIndicatorButton = {
        let joinPartyButton = ActivityIndicatorButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        joinPartyButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        joinPartyButton.setBackgroundColor(UIColor.Partybox.blue)
        joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        return joinPartyButton
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
            make.top.equalTo(self.partyboxImageView.snp.bottom).offset(80)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(40)
        })
    }
    
    // MARK: - Action Functions
    
    @objc private func startPartyButtonPressed() {
        self.delegate.menuView(self, startPartyButtonPressed: true)
    }
    
    @objc private func joinPartyButtonPressed() {
        self.delegate.menuView(self, joinPartyButtonPressed: true)
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
        
        let colors = [UIColor.Partybox.red, UIColor.Partybox.blue, UIColor.Partybox.green, UIColor.Partybox.purple]
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
