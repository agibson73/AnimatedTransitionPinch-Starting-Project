//
//  AlbumCollectionViewController.swift
//  AnimatedTransitionPinch
//
//  Created by Alex Gibson on 3/29/18.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class AlbumCollectionViewController: UIViewController {
 
    let cellIdentifier = "albumCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}


extension AlbumCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell{
            if let img = UIImage(named: images[indexPath.item]){
                cell.imageView.image = img
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
