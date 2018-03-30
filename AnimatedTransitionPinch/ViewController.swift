//
//  ViewController.swift
//  AnimatedTransitionPinch
//
//  Created by Alex Gibson on 3/29/18.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var interactionController: UIPercentDrivenInteractiveTransition?
    let cellIdentifier = "albumCell"
    var pinchTransition = PinchAnimatedTransition()
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [["cats0","cats1","cats2","cats3","cats4","cats5"],["landscapes0","landscapes1","landscapes2","landscapes3","landscapes4","landscapes5","landscapes6","landscapes7"],["peoplesBack0","peoplesBack1","peoplesBack2","peoplesBack3"],
        ["randoms0","randoms1","randoms2","randoms3","randoms4","randoms5"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self

        self.navigationController?.delegate = self
    }
    

    @objc func panHandler(gestureRecognizer:UIPinchGestureRecognizer) {

//        switch gestureRecognizer.state {
//        case .began:
//            self.interactionController = UIPercentDrivenInteractiveTransition()
//            moveToNext()
//
//        case .changed:
//            let completionProgress = //probably some scale or distance
//            self.interactionController!.update(completionProgress)
//
//        case .ended:
//
//            let completionProgress = //probably some scale or distance
//            if completionProgress >= 0.5 {
//                self.interactionController!.finish()
//            } else {
//                self.interactionController!.cancel()
//            }
//
//            self.interactionController = nil
//
//        default:
//            self.interactionController?.cancel()
//            self.interactionController = nil
//        }
    }

}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell{
            if let img = UIImage(named: images[indexPath.item].last!){
                cell.imageView.image = img
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            pinchTransition.startingRect = cell.convert(cell.bounds, to: UIApplication.shared.keyWindow)
            pinchTransition.images = self.images[indexPath.row]
            self.performSegue(withIdentifier: "toAlbumViewController", sender: self.images[indexPath.row])
        }
        
      
    }
}

extension ViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC == self && toVC is AlbumCollectionViewController{
            pinchTransition.reverse = false
            return pinchTransition
            
        }else if fromVC is AlbumCollectionViewController && toVC == self{
            pinchTransition.reverse = true
            return pinchTransition
        }else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    


    func moveToNext() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "AlbumCollectionVC") as! AlbumCollectionViewController
        self.navigationController!.pushViewController(destination, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? AlbumCollectionViewController,
            let images = sender as? [String]{
            dvc.images = images
        }
    }
}

