//
//  PinchAnimatedTransition.swift
//  AnimatedTransitionPinch
//
//  Created by Alex Gibson on 3/29/18.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

    open class PinchAnimatedTransition: NSObject,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning {
        
        var reverse: Bool = false
        var duration = 0.75
        var startingRect : CGRect?
        var finalRects = NSMutableDictionary()
        var images = [String]()
        var snapShots = [UIView]()
        
        
     open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else{return}
            guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else{return}
             toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            container.addSubview(toViewController.view)
            var collectionView : UICollectionView?
            if reverse == false {
                //toView should be the albumView
                toViewController.view.alpha = 0
                if let collection = toViewController.view.viewWithTag(1000) as? UICollectionView{
                    collectionView = collection
                    toViewController.view.layoutIfNeeded()
                    let visibleCells = collection.indexPathsForVisibleItems
                        .sorted { $0.section < $1.section || $0.row < $1.row }
                        .flatMap { collection.cellForItem(at: $0) }
                    for x in (0..<visibleCells.count){
                        //we can assume for now 0 will corespond to the indexpath
                        let viewDict = NSMutableDictionary()
                        
                        viewDict.setValue(visibleCells[x].convert(visibleCells[x].bounds, to: UIApplication.shared.keyWindow), forKey: "frame")
                        viewDict.setValue(visibleCells[x].convert(visibleCells[x].center, to: UIApplication.shared.keyWindow), forKey: "center")
                        let snapshot = visibleCells[x].snapshotViewWithLayers()
                        snapshot.frame = startingRect!
                        container.addSubview(snapshot)
                        viewDict.setValue(snapshot, forKey: "snapshot")
                        finalRects.setValue(viewDict, forKey: images[x])
                    }
                    collectionView?.alpha = 0
                }
                
               
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: { () -> Void in
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { () -> Void in
                        fromViewController.view.alpha = 0
                        for img in self.images{
                            if let viewInfo = self.finalRects.value(forKey: img) as? NSDictionary,
                                let finalFrame = viewInfo.value(forKey: "frame") as? CGRect,
                                let snap = viewInfo.value(forKey: "snapshot") as? UIView {
                                snap.frame = finalFrame
                            }
                        }
                        toViewController.view.alpha = 1
                    })
                    
                    
                }, completion: { finished in
                    for img in self.images{
                        if let viewInfo = self.finalRects.value(forKey: img) as? NSDictionary,
                            let snap = viewInfo.value(forKey: "snapshot") as? UIView {
                            snap.removeFromSuperview()
                            self.finalRects.removeObject(forKey: img)
                        }
                    }
                    collectionView?.alpha = 1
                    transitionContext.completeTransition(true)
                    
                })
            }
            else {
                //toView should be the albumView
                container.addSubview(fromViewController.view)
                container.insertSubview(toViewController.view, belowSubview: fromViewController.view)
                
                if let collection = fromViewController.view.viewWithTag(1000) as? UICollectionView{
                    
                    let visibleCells = collection.indexPathsForVisibleItems
                        .sorted { $0.section < $1.section || $0.row < $1.row }
                        .flatMap { collection.cellForItem(at: $0) }
                    for x in (0..<visibleCells.count){
                        //we can assume for now 0 will corespond to the indexpath
                        let viewDict = NSMutableDictionary()
                        let frame = visibleCells[x].convert(visibleCells[x].bounds, to: UIApplication.shared.keyWindow)
                        viewDict.setValue(visibleCells[x].convert(visibleCells[x].bounds, to: UIApplication.shared.keyWindow), forKey: "frame")
                        viewDict.setValue(visibleCells[x].convert(visibleCells[x].center, to: UIApplication.shared.keyWindow), forKey: "center")
                        let snapshot = visibleCells[x].snapshotViewWithLayers()
                        snapshot.frame = frame
                        container.addSubview(snapshot)
                     
                        viewDict.setValue(snapshot, forKey: "snapshot")
                        finalRects.setValue(viewDict, forKey: images[x])
                    }
                    collectionView = collection
                    collectionView?.alpha = 0
                }
         
                
                toViewController.view.alpha = 1
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: { () -> Void in
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { () -> Void in
                       fromViewController.view.alpha = 0
                        for img in self.images{
                            if let viewInfo = self.finalRects.value(forKey: img) as? NSDictionary,
                                let snap = viewInfo.value(forKey: "snapshot") as? UIView {
                                snap.frame = self.startingRect!
                            }
                        }
                    })
                    
                    
                }, completion: { finished in
                    transitionContext.completeTransition(true)
                    for img in self.images{
                        if let viewInfo = self.finalRects.value(forKey: img) as? NSDictionary,
                            let snap = viewInfo.value(forKey: "snapshot") as? UIView {
                            snap.removeFromSuperview()
                            self.finalRects.removeObject(forKey: img)
                        }
                    }
                    collectionView?.alpha = 1
                })
            }
            
        }
        
        open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return duration
        }

        
}



