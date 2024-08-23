//
//  CustomCircleView.swift
//  AnimationTestApp
//
//  Created by Anastasiya Beginina on 15.04.2024.
//

import UIKit

class CustomCircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    required init?(coder: NSCoder) {
        fatalError("coder has not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.clipsToBounds = false
    }
    
}
