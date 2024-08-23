//
//  ViewController.swift
//  AnimationTestApp
//
//  Created by Anastasiya Beginina on 15.04.2024.
//

import UIKit
import SwiftUI

class AnimationViewController: UIViewController {
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let customView = CustomCircleView()
    
    private var panGestureAnchorPoint: CGPoint?
    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(customView)

        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        updateConstraints()
    }

    private func updateConstraints() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        centerXConstraint = customView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        centerYConstraint = customView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        guard let centerXConstraint = centerXConstraint, let centerYConstraint = centerYConstraint else { return }
        
        NSLayoutConstraint.activate([
            centerXConstraint,
            centerYConstraint,
            customView.widthAnchor.constraint(equalToConstant: 150),
            customView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer === gestureRecognizer else { assert(false); return }

        switch gestureRecognizer.state {
        case .began:
            assert(panGestureAnchorPoint == nil)
            panGestureAnchorPoint = gestureRecognizer.location(in: view) // (2)

        case .changed:
            guard let panGestureAnchorPoint = panGestureAnchorPoint else { assert(false); return }

            let gesturePoint = gestureRecognizer.location(in: view)

            centerXConstraint?.constant += gesturePoint.x - panGestureAnchorPoint.x
            centerYConstraint?.constant += gesturePoint.y - panGestureAnchorPoint.y
            self.panGestureAnchorPoint = gesturePoint

        case .cancelled, .ended:
            panGestureAnchorPoint = nil

        case .failed, .possible:
            assert(panGestureAnchorPoint == nil)
            break
        }
    }
}


#Preview {
    AnimationViewController()
}
