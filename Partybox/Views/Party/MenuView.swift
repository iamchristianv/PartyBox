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
    
    lazy var startPartyButton: ActivityButton = {
        let startPartyButton = ActivityButton()
        startPartyButton.setTitle("Start Party", for: .normal)
        startPartyButton.setTitleFont(UIFont.avenirNextMediumName, size: 24)
        startPartyButton.setBackgroundColor(UIColor.Partybox.red)
        return startPartyButton
    }()
    
    lazy var joinPartyButton: ActivityButton = {
        let joinPartyButton = ActivityButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(UIFont.avenirNextMediumName, size: 24)
        joinPartyButton.setBackgroundColor(UIColor.Partybox.blue)
        return joinPartyButton
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
        extraLightConfettiBehavior.resistance = 5.5
        return extraLightConfettiBehavior
    }()
    
    lazy var lightConfettiBehavior: UIDynamicItemBehavior = {
        let lightConfettiBehavior = UIDynamicItemBehavior()
        lightConfettiBehavior.allowsRotation = true
        lightConfettiBehavior.resistance = 5.0
        return lightConfettiBehavior
    }()
    
    lazy var mediumConfettiBehavior: UIDynamicItemBehavior = {
        let mediumConfettiBehavior = UIDynamicItemBehavior()
        mediumConfettiBehavior.allowsRotation = true
        mediumConfettiBehavior.resistance = 4.5
        return mediumConfettiBehavior
    }()
    
    lazy var heavyConfettiBehavior: UIDynamicItemBehavior = {
        let heavyConfettiBehavior = UIDynamicItemBehavior()
        heavyConfettiBehavior.allowsRotation = true
        heavyConfettiBehavior.resistance = 4.0
        return heavyConfettiBehavior
    }()
    
    lazy var extraHeavyConfettiBehavior: UIDynamicItemBehavior = {
        let extraHeavyConfettiBehavior = UIDynamicItemBehavior()
        extraHeavyConfettiBehavior.allowsRotation = true
        extraHeavyConfettiBehavior.resistance = 3.5
        return extraHeavyConfettiBehavior
    }()
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.startPartyButton)
        self.addSubview(self.joinPartyButton)
        
        self.startPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(250)
            make.height.equalTo(62.5)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(48)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(250)
            make.height.equalTo(62.5)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(48)
        })
    }
    
    // MARK: - Animation Methods
    
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
    
    // MARK: - Confetti Methods
    
    func dropConfettiPiece() {
        var confettiPiece: ShapeView!
        
        let shapes = [SquareView.self, TriangleView.self, CircleView.self]
        let randomShape = shapes[Int(arc4random()) % shapes.count]
        
        let randomSize = Int(arc4random_uniform(5) + 10)
        let randomFrame = CGRect(x: Int(arc4random()) % Int(self.frame.size.width), y: -randomSize, width: randomSize, height: randomSize)
        
        let colors = [UIColor.Partybox.red, UIColor.Partybox.blue, UIColor.Partybox.green, UIColor.Partybox.purple]
        let randomColor = colors[Int(arc4random()) % colors.count]
        
        if randomShape == SquareView.self {
            confettiPiece = SquareView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == TriangleView.self {
            confettiPiece = TriangleView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == CircleView.self {
            confettiPiece = CircleView(frame: randomFrame, color: randomColor)
        }
        
        self.animator.referenceView?.insertSubview(confettiPiece, at: 0)
        self.gravityBehavior.addItem(confettiPiece)
        
        let randomSpeed = CGFloat(arc4random_uniform(4) + 2)
        let randomDirection = CGFloat(arc4random_uniform(2))
        let randomAngularVelocity = randomDirection == 0 ? randomSpeed : -randomSpeed
        
        let randomResistance = arc4random_uniform(5)
        
        if randomResistance == 0 {
            self.extraLightConfettiBehavior.addItem(confettiPiece)
            self.extraLightConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confettiPiece)
        }
        else if randomResistance == 1 {
            self.lightConfettiBehavior.addItem(confettiPiece)
            self.lightConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confettiPiece)
        }
        else if randomResistance == 2 {
            self.mediumConfettiBehavior.addItem(confettiPiece)
            self.mediumConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confettiPiece)
        }
        else if randomResistance == 3 {
            self.heavyConfettiBehavior.addItem(confettiPiece)
            self.heavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confettiPiece)
        }
        else if randomResistance == 4 {
            self.extraHeavyConfettiBehavior.addItem(confettiPiece)
            self.extraHeavyConfettiBehavior.addAngularVelocity(randomAngularVelocity, for: confettiPiece)
        }
    }
    
    func updateConfettiPieceGravityDirection(_ direction: CGVector) {
        self.gravityBehavior.gravityDirection = direction
    }
    
}
