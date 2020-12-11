//
//  Exercise Craft.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/23/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit
import AudioToolbox
import StoreKit

protocol userDelegate {
    func Increment()
}
protocol ErrorDelegate {
    func showError(vc: ViewController)
}

class ExerciseCraftViewController: ViewController {
    @IBOutlet var ExerciseCraftTableView: UITableView!
    var imagecell: BodyImageCell?
    var selectcell: BodyPartSelectCell?
    
    let parts = ["I would like to work on my Abs", "I would like to work on my Arms", "I would like to work on my Back", "I would like to work on my Buttocks", "I would like to work on my Cardio/Heart", "I would like to work on my Chest", "I would like to work on my Hips", "I would like to work on my Legs", "I would like to work on my Shoulders"]
    let part_images = ["Abs", "Arms", "Back", "Buttocks", "Cardio Heart", "Chest", "Hips", "Legs", "Shoulders"]
    var exercise = ""
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExerciseCraftTableView.delegate = self
        ExerciseCraftTableView.dataSource = self
        Increment()

    }
    
    // Sets the Selector Cell Picker View Settings
    func configure() {
        selectcell?.select_text.inputView = selectcell?.select_PickerView
        selectcell?.select_PickerView.delegate = self
        selectcell?.select_PickerView.dataSource = self
        
        selectcell?.select_PickerView.tag = 1
    }
    
    // Checks if the user selected an exercise, if yes pass it to the ExercisesViewController
    // else don't do anything
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(exercise == "")
        {
            print("Empty")
        }
        else
        {
            guard let ExerciseVC = segue.destination as? ExercisesViewController else { return }
            ExerciseVC.exercise = exercise
        }
    }
    
    // Checks if the exercise field is empty, if it is, play a sound and notify the user
    // else proceed with the segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(exercise == "" && identifier == "Confirm")
        {
            showError(vc: self)
            return false
        }
        else{
            return true
        }
    }
    
}

extension ExerciseCraftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 425
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath)
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Body", for: indexPath) as! BodyImageCell
            imagecell = cell
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Which_Body_Part", for: indexPath)
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Tracker/Calculator", for: indexPath)
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedBodyPart", for: indexPath) as! BodyPartSelectCell
            selectcell = cell
            self.configure()
            return selectcell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Confirm", for: indexPath)
        return cell
    }
    
}

extension ExerciseCraftViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return parts.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return parts[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectcell!.select_text.text = parts[row]
            selectcell!.select_text.resignFirstResponder()
            imagecell?.BodyImage.image = UIImage(named: part_images[row])
            self.exercise = part_images[row]
        default:
            return
        }
    }
}

extension ExerciseCraftViewController: userDelegate {
    func Increment() {
        if let counter = defaults.value(forKey: "Opened") as? Int {
            defaults.set(defaults.integer(forKey: "Opened") + 1, forKey: "Opened")
            if(counter % 5 == 0)
            {
                SKStoreReviewController.requestReview()
            }
        }
    }
}

extension ExerciseCraftViewController: ErrorDelegate {
    func showError(vc: ViewController) {
        AudioServicesPlaySystemSound(SystemSoundID(1112))
        let alert = UIAlertController(title: "No Body Part Selected", message: "You did not select a body part", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
            }))
        
        vc.present(alert, animated: true)
    }
}
