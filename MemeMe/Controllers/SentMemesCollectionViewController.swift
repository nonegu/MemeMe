//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 18.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let kCollectionViewCellID = "collectionViewCell"
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: (view.frame.width/3)-2, height: (view.frame.width/3)-2)
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 2
        collectionView!.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
    }
    
    // MARK: CollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.itemToShow = indexPath.row
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
}
