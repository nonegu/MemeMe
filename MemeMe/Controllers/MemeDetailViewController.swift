//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 20.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    //MARK: Properties
    var meme: Meme!
    
    //MARK: Outlets
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        tabBarController?.tabBar.isHidden = true
        // MARK: Right BarButtonItem initilization
        setRightBarButton()
        memedImageView.image = meme.memedImage
    }
    
    func setRightBarButton() {
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editPressed))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func editPressed() {
        
    }
    
}
