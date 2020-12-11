//
//  BodyPartSelectCell.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/26/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit

class BodyPartSelectCell: UITableViewCell {

    @IBOutlet var select_text: UITextField!
    
    let parts = ["I would like to work on my Abs", "I would like to work on my Arms", "I would like to work on my Back", "I would like to work on my Buttocks", "I would like to work on my Cardio/Heart", "I would like to work on my Chest", "I would like to work on my Hips", "I would like to work on my Legs", "I would like to work on my Shoulders"]
    var select_PickerView = UIPickerView()
    
    func configure() {
        
        select_text.inputView = select_PickerView
        select_PickerView.delegate = self
        select_PickerView.dataSource = self
        
        select_PickerView.tag = 1
    }

    
}

extension BodyPartSelectCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            select_text.text = parts[row]
            select_text.resignFirstResponder()
        default:
            return
        }
    }
}
