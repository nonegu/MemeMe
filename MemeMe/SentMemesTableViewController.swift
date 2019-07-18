//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 18.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController  {
    
    override func viewDidLoad() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeholdercell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
        return placeholdercell
    }
    
}
