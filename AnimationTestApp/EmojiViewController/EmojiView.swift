//
//  EmojiView.swift
//  AnimationTestApp
//
//  Created by Anastasiya Beginina on 19.04.2024.
//

import UIKit

protocol EmojiAnimationProtocol {
    func configureView(emojiSize: CGFloat, viewHeight: CGFloat)
    func updateGravity(x: CGFloat, y: CGFloat)
    func createEmoji(at location: CGPoint)
    func shakeEmojis()
    func startContinuousEmojiGeneration(_ gestureRecognizer: UILongPressGestureRecognizer)
    func stopContinuousEmojiGeneration()
}

class EmojiView: UIView {
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    private var emojiSize: CGFloat?
    private var emojiLabels: [UILabel] = []
    private var touchTimer: Timer?
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var behaviour: UIDynamicItemBehavior!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    // MARK: Configure
    
    private func setup() {
        animator = UIDynamicAnimator(referenceView: self)
        gravity = UIGravityBehavior(items: emojiLabels)
        behaviour = UIDynamicItemBehavior(items: emojiLabels)
        collision = UICollisionBehavior(items: emojiLabels)
        
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        behaviour.elasticity = 0.7
        behaviour.density = 1.5
        animator.addBehavior(collision)
        animator.addBehavior(gravity)
        animator.addBehavior(behaviour)
        backgroundColor = .white
    }
    
    private func randomEmoji() -> String {
        let emojiList = "🥎☕️🍧🥣🎈🎀🧽📍✂️💚🧿💴💿🎲🥦🥑🌍"
        guard let randomEmoji = emojiList.randomElement() else { return "" }
        
        return String(randomEmoji)
    }

    private func explodeEmojis() {
        guard let animator = animator else { return }
        
        let explosionCenter = self.center
        
        for emoji in emojiLabels {
            let pushBehavior = UIPushBehavior(items: [emoji], mode: .instantaneous)
            
            let offsetX = emoji.center.x - explosionCenter.x
            let offsetY = emoji.center.y - explosionCenter.y
            let angle = atan2(offsetY, offsetX)
            pushBehavior.magnitude = 5
            pushBehavior.angle = angle
            pushBehavior.active = true

            animator.addBehavior(pushBehavior)
            generator.impactOccurred(intensity: 1.0)
        }
    }
}

extension EmojiView: EmojiAnimationProtocol {
    func configureView(emojiSize: CGFloat, viewHeight: CGFloat) {
        self.emojiSize = emojiSize
    }
    
    func createEmoji(at location: CGPoint) {
        guard let emojiSize else { return }
        
        let emojiLabel = UILabel()
        emojiLabel.text = randomEmoji()
        emojiLabel.font = UIFont.systemFont(ofSize: emojiSize)
        emojiLabel.sizeToFit()
        emojiLabel.center = location
        addSubview(emojiLabel)
        emojiLabels.append(emojiLabel)
        gravity.addItem(emojiLabel)
        collision.addItem(emojiLabel)
        behaviour.addItem(emojiLabel)
    }
    
    func updateGravity(x: CGFloat, y: CGFloat) {
        gravity.gravityDirection = CGVector(dx: x, dy: y * -1)
    }
    
    func shakeEmojis() {
        collision.translatesReferenceBoundsIntoBoundary = false
        explodeEmojis()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] timer in
            guard let self = self else { return }

            self.emojiLabels.forEach { emojiLabel in
                emojiLabel.removeFromSuperview()
                self.gravity.removeItem(emojiLabel)
                self.collision.removeItem(emojiLabel)
                self.behaviour.removeItem(emojiLabel)
            }

            self.emojiLabels.removeAll()
            self.collision.translatesReferenceBoundsIntoBoundary = true
            timer.invalidate()
        }
    }
    
    func startContinuousEmojiGeneration(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        touchTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            generator.impactOccurred()
            createEmoji(at: location)
        }
    }
    
    func stopContinuousEmojiGeneration() {
        guard let touchTimer else { return }
        
        touchTimer.invalidate()
        self.touchTimer = nil
    }
}

extension EmojiView: UICollisionBehaviorDelegate {
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        beganContactFor item1: any UIDynamicItem,
        with item2: any UIDynamicItem,
        at p: CGPoint
    ) {
        generator.impactOccurred(intensity: 0.5)
    }
}
