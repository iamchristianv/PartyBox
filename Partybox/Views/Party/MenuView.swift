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
    
    lazy var partyboxImageView: UIImageView = {
        let partyboxImageView = UIImageView()
        partyboxImageView.image = UIImage(named: "Box")
        return partyboxImageView
    }()
    
    lazy var startPartyButton: ActivityButton = {
        let startPartyButton = ActivityButton()
        startPartyButton.setTitle("Start Party", for: .normal)
        startPartyButton.setTitleFont(UIFont.avenirNextRegularName, size: 22)
        startPartyButton.setBackgroundColor(UIColor.Partybox.red)
        return startPartyButton
    }()
    
    lazy var joinPartyButton: ActivityButton = {
        let joinPartyButton = ActivityButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(UIFont.avenirNextRegularName, size: 22)
        joinPartyButton.setBackgroundColor(UIColor.Partybox.blue)
        return joinPartyButton
    }()
    
    lazy var findPartyButton: ActivityButton = {
        let findPartyButton = ActivityButton()
        findPartyButton.setTitle("Find Party", for: .normal)
        findPartyButton.setTitleFont(UIFont.avenirNextRegularName, size: 22)
        findPartyButton.setBackgroundColor(UIColor.Partybox.purple)
        return findPartyButton
    }()
    
    lazy var visitStoreButton: ActivityButton = {
        let visitStoreButton = ActivityButton()
        visitStoreButton.setTitle("Visit Store", for: .normal)
        visitStoreButton.setTitleFont(UIFont.avenirNextRegularName, size: 22)
        visitStoreButton.setBackgroundColor(UIColor.Partybox.green)
        return visitStoreButton
    }()
    
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.addBehavior(self.gravityBehavior)
        animator.addBehavior(self.extraLightConfettiBehavior)
        animator.addBehavior(self.lightConfettiBehavior)
        animator.addBehavior(self.mediumConfettiBehavior)
        animator.addBehavior(self.heavyConfettiBehavior)
        animator.addBehavior(self.extraHeavyConfettiBehavior)
        return animator
    }()
    
    lazy var gravityBehavior: UIGravityBehavior = {
        let gravityBehavior = UIGravityBehavior()
        return gravityBehavior
    }()
    
    lazy var extraLightConfettiBehavior: UIDynamicItemBehavior = {
        let extraLightConfettiBehavior = UIDynamicItemBehavior()
        extraLightConfettiBehavior.allowsRotation = true
        extraLightConfettiBehavior.resistance = 6.0
        return extraLightConfettiBehavior
    }()
    
    lazy var lightConfettiBehavior: UIDynamicItemBehavior = {
        let lightConfettiBehavior = UIDynamicItemBehavior()
        lightConfettiBehavior.allowsRotation = true
        lightConfettiBehavior.resistance = 5.5
        return lightConfettiBehavior
    }()
    
    lazy var mediumConfettiBehavior: UIDynamicItemBehavior = {
        let mediumConfettiBehavior = UIDynamicItemBehavior()
        mediumConfettiBehavior.allowsRotation = true
        mediumConfettiBehavior.resistance = 5.0
        return mediumConfettiBehavior
    }()
    
    lazy var heavyConfettiBehavior: UIDynamicItemBehavior = {
        let heavyConfettiBehavior = UIDynamicItemBehavior()
        heavyConfettiBehavior.allowsRotation = true
        heavyConfettiBehavior.resistance = 4.5
        return heavyConfettiBehavior
    }()
    
    lazy var extraHeavyConfettiBehavior: UIDynamicItemBehavior = {
        let extraHeavyConfettiBehavior = UIDynamicItemBehavior()
        extraHeavyConfettiBehavior.allowsRotation = true
        extraHeavyConfettiBehavior.resistance = 4.0
        return extraHeavyConfettiBehavior
    }()
    
    // MARK: - Initialization Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
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
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(16)
        })
        
        self.findPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.joinPartyButton.snp.bottom).offset(16)
        })
        
        self.visitStoreButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-40)
        })
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
    
    // MARK: - Confetti Functions
    
    @objc func dropConfetti() {
        var confetti: ShapeView!
        
        let shapes = [SquareView.self, TriangleView.self, CircleView.self]
        let randomShape = shapes[Int(arc4random()) % shapes.count]
        
        let randomSize = Int(arc4random_uniform(5) + 10)
        let randomFrame = CGRect(x: Int(arc4random()) % Int(self.frame.size.width), y: -randomSize, width: randomSize, height: randomSize)
        
        let colors = [UIColor.Partybox.red, UIColor.Partybox.blue, UIColor.Partybox.green, UIColor.Partybox.purple]
        let randomColor = colors[Int(arc4random()) % colors.count]
        
        if randomShape == SquareView.self {
            confetti = SquareView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == TriangleView.self {
            confetti = TriangleView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == CircleView.self {
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
        }
        else if randomResistance == 1 {
            self.lightConfettiBehavior.addItem(confetti)
            self.lightConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        }
        else if randomResistance == 2 {
            self.mediumConfettiBehavior.addItem(confetti)
            self.mediumConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        }
        else if randomResistance == 3 {
            self.heavyConfettiBehavior.addItem(confetti)
            self.heavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        }
        else if randomResistance == 4 {
            self.extraHeavyConfettiBehavior.addItem(confetti)
            self.extraHeavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confetti)
        }
    }
    
    func updateConfettiGravityDirection(_ direction: CGVector) {
        self.gravityBehavior.gravityDirection = direction
    }
    
}
