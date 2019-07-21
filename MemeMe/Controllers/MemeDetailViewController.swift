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
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var itemToShow: Int!
    
    //MARK: Outlets
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        // MARK: Right BarButtonItem initilization
        setRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memedImageView.image = appDelegate.memes[itemToShow].memedImage
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
        memeEditorVC.itemToEdit = itemToShow
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
}
