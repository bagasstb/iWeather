//
//  iButton.swift
//  iWheater
//
//  Created by bagasstb on 06/03/19.
//  Copyright © 2019 xProject. All rights reserved.
//

import UIKit

/// Enable to edit via Attribute inspector
@IBDesignable class iButton: UIButton {
    /// Create button
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    /// Storyboard/.xib create button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    /// Storyboard render button control
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        refreshCorners(value: cornerRadius)
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    /// Helper update corner radius
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    /// Helper update shadow radius
    func refreshShadowRadius(value: CGFloat) {
        layer.shadowRadius = value
    }
    
    /// Helper update shadow opacity
    func refreshShadowOpacity(value: Float) {
        layer.shadowOpacity = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 15 {
        didSet {
            refreshShadowRadius(value: shadowRadius)
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 15 {
        didSet {
            refreshShadowOpacity(value: shadowOpacity)
        }
    }
    
}
