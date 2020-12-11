//
//  CalculatorTableViewController.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/25/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit

class CalculatorTableViewController: ViewController {
    @IBOutlet var CalculatorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CalculatorTable.delegate = self
        CalculatorTable.dataSource = self
        
        // Listens for when the keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hides keyboard when the user taps something that is not a text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // Function to hide the keyboard
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    // Deinitializes listeners when keyboard disappears
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        // If the keyboard appears, adjust the frame to fit
        // else when it disappears reset it to normal
        if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    
}


extension CalculatorTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 210
        }
        return 270
    }
}


extension CalculatorTableViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IdealWeight", for: indexPath) as! IdealWeightCell
            cell.configure()
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MacrosAmount", for: indexPath) as! MacrosAmountCell
            cell.configure()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCalories", for: indexPath) as! CaloriesCell
        cell.configure()
        return cell
    }
}

