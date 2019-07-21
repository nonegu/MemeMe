//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 18.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController  {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 12)!,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: TableView Delegate and DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MemeTableViewCell
        cell.memeImageView.image = appDelegate.memes[indexPath.row].originalImage
        let text = "\(appDelegate.memes[indexPath.row].topText)...\(appDelegate.memes[indexPath.row].bottomText)"
        cell.memeText.text = text
        let topText = appDelegate.memes[indexPath.row].topText
        let attributedTopText = NSAttributedString(string: topText, attributes: memeTextAttributes)
        cell.memeTopText.attributedText = attributedTopText
        let bottomText = appDelegate.memes[indexPath.row].bottomText
        let attributedBottomText = NSAttributedString(string: bottomText, attributes: memeTextAttributes)
        cell.memeBottomText.attributedText = attributedBottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: TableViewCell Editing Style
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.itemToShow = indexPath.row
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
}
