//
//  EmojiViewController.swift
//  AnimationTestApp
//
//  Created by Anastasiya Beginina on 15.04.2024.
//

import CoreMotion
import UIKit
import SwiftUI

class EmojiViewController: UIViewController {
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    private let emojiCooldown: TimeInterval = 0.1
    private let emojiSize: CGFloat = 40
    private let motionManager = CMMotionManager()
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    private var lastEmojiTimestamp: TimeInterval = 0
    private lazy var emojiView: EmojiAnimationProtocol = EmojiView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
        setupMotionDetection()
    }
    
    private func setupView() {
        emojiView.configureView(emojiSize: emojiSize, viewHeight: view.bounds.height)
        view = (emojiView as! UIView)
    }
    
    private func setupGestures() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        
        longPressGestureRecognizer.minimumPressDuration = 0.3
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(longPressGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
        
        tapGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        longPressGestureRecognizer.delegate = self
    }
    
    // MARK: - Gestures
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        emojiView.createEmoji(at: location)
    }
    
    @objc private func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            emojiView.startContinuousEmojiGeneration(gestureRecognizer)
        case .ended, .cancelled, .failed:
            emojiView.stopContinuousEmojiGeneration()
        default:
            break
        }
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        emojiView.stopContinuousEmojiGeneration()
        switch gestureRecognizer.state {
        case .changed, .began:
            let currentTime = NSDate().timeIntervalSince1970
            if currentTime - lastEmojiTimestamp >= emojiCooldown {
                generator.impactOccurred()
                lastEmojiTimestamp = currentTime
                emojiView.createEmoji(at: gestureRecognizer.location(in: view))
            }
        case .ended, .cancelled, .failed:
            emojiView.stopContinuousEmojiGeneration()
        default:
            break
        }
    }
    
    // MARK: - Motion
    
    private func setupMotionDetection() {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
            guard let data, let self else { return }
            self.emojiView.updateGravity(x: data.gravity.x, y: data.gravity.y)
        }
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            emojiView.shakeEmojis()
        }
    }
}

extension EmojiViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


#Preview {
    EmojiViewController()
}
