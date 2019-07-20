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
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
    }
    
    // MARK: CollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
}
