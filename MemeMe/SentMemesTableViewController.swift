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

    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    // MARK: TableView Delegate and DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        cell.imageView?.image = appDelegate.memes[indexPath.row].memedImage
        let text = "\(appDelegate.memes[indexPath.row].topText)...\(appDelegate.memes[indexPath.row].bottomText)"
        cell.textLabel?.text = text
        return cell
    }
    
}
