//
//  AddViewController.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 12/10/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit

class AddViewController : UIViewController {
    @IBOutlet var AddTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddTableView.delegate = self
        AddTableView.dataSource = self

    }
    
}

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as! NameCell
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sets", for: indexPath) as! SetsCell
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Reps", for: indexPath) as! RepsCell
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Prev", for: indexPath) as! PrevCell
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Current", for: indexPath) as! CurrentCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Next", for: indexPath) as! NextCell
        return cell
    }
    
}
