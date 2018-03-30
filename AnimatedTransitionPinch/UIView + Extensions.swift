//
//  UIView + Extensions.swift
//  AnimatedTransitionPinch
//
//  Created by Alex Gibson on 3/29/18.
//  Copyright © 2018 AG. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else{ return nil}
        context.translateBy(x: -bounds.origin.x, y: -bounds.origin.y)
        self.layoutIfNeeded()
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func snapshotView() -> UIView? {
        
        
        if let snapshotImage = snapshotImage() {
            let v = UIImageView(image: snapshotImage)
            v.bounds = self.bounds
            v.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            v.layer.masksToBounds = true
            return v
        } else {
            return nil
        }
    }
    
    /**
     - Returns: a snapshot view for animation
     */
    public func snapshotViewWithLayers() -> UIView {
        
        self.alpha = 1
        // capture a snapshot without cornerRadius
        let oldCornerRadius = self.layer.cornerRadius
        self.layer.cornerRadius = 0
        let oldBorderWidth = self.layer.borderWidth
        self.layer.borderWidth = 0
        
        
        let CV = self.snapshotView()!
        CV.translatesAutoresizingMaskIntoConstraints = true
        let snapshot = UIView(frame: self.frame)
        snapshot.bounds = self.bounds
        snapshot.addSubview(CV)
        self.layer.cornerRadius = oldCornerRadius
        self.layer.borderWidth = oldBorderWidth
        // the Snapshot's contentView must have hold the cornerRadius value,
        // since the snapshot might not have maskToBounds set
        let contentView = snapshot.subviews[0]
        contentView.layer.cornerRadius = self.layer.cornerRadius
        contentView.layer.masksToBounds = true
        
        snapshot.layer.cornerRadius = self.layer.cornerRadius
        snapshot.layer.zPosition = self.layer.zPosition
        snapshot.layer.opacity = layer.opacity
        snapshot.layer.isOpaque = layer.isOpaque
        snapshot.layer.anchorPoint = layer.anchorPoint
        snapshot.layer.masksToBounds = layer.masksToBounds
        snapshot.layer.borderColor = layer.borderColor
        snapshot.layer.borderWidth = layer.borderWidth
        snapshot.layer.transform = layer.transform
        snapshot.layer.shadowRadius = layer.shadowRadius
        snapshot.layer.shadowOpacity = layer.shadowOpacity
        snapshot.layer.shadowColor = layer.shadowColor
        snapshot.layer.shadowOffset = layer.shadowOffset
        
        return snapshot
    }
    
    
}
