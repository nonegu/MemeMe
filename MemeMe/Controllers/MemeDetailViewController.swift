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
    var itemToEdit: Int!
    
    //MARK: Outlets
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        // MARK: Right BarButtonItem initilization
        setRightBarButton()
        memedImageView.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setRightBarButton() {
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editPressed))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func editPressed() {
        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.memeToEdit = meme
        memeEditorVC.itemToEdit = itemToEdit
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
}
