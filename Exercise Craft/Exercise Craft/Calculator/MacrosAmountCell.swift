//
//  MacrosAmount.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/26/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit
import AudioToolbox

class MacrosAmountCell: UITableViewCell {
    
    @IBOutlet var MA_activity_text: UITextField!
    @IBOutlet var MA_height_text: UITextField!
    @IBOutlet var MA_weight_text: UITextField!
    @IBOutlet var MA_gender_text: UITextField!
    @IBOutlet var MA_age_text: UITextField!
    @IBOutlet var MA_goals_text: UITextField!
    @IBOutlet var MA_VC: ViewController!
    
    let heights = ["4'8", "4'9", "4'10", "4'11", "5'1", "5'2", "5'3", "5'4", "5'5", "5'6", "5'7", "5'8", "5'9", "5'11", "6'0", "6'1", "6'2", "6'3", "6'4", "6'5", "6'6"]
    
    let genders = ["Male", "Female"]
    
    let activity_levels = ["1 (BMR)", "2 (Little/No Exercise)", "3 (1-3 Exercises weekly)", "4 (4-5 Exercises weekly)", "5 (Daily Exercises/Some Intense Exercises)", "6 (Intense Exercises Daily)", "7 (Very Intense Exercises Daily"]
    
    let goals = ["Maintain Weight", "Mild Weight Loss", "Weight Loss", "Extreme Weight Loss", "Mild Weight Gain", "Weight Gain", "Extreme Weight Gain"]
    
    var MA_height_PickerView = UIPickerView()
    var MA_gender_PickerView = UIPickerView()
    var MA_activity_PickerView = UIPickerView()
    var MA_goals_PickerView = UIPickerView()
    
    var carbs = 0
    var fat = 0
    var protein = 0

    func configure() {
        
        MA_height_text.inputView = MA_height_PickerView
        MA_gender_text.inputView = MA_gender_PickerView
        MA_activity_text.inputView = MA_activity_PickerView
        MA_goals_text.inputView = MA_goals_PickerView
        
        MA_height_PickerView.delegate = self
        MA_height_PickerView.dataSource = self
        MA_gender_PickerView.delegate = self
        MA_gender_PickerView.dataSource = self
        MA_activity_PickerView.delegate = self
        MA_activity_PickerView.dataSource = self
        MA_goals_PickerView.delegate = self
        MA_goals_PickerView.dataSource = self
        
        MA_weight_text.delegate = self
        MA_age_text.delegate = self
        
        MA_height_PickerView.tag = 1
        MA_gender_PickerView.tag = 2
        MA_activity_PickerView.tag = 3
        MA_goals_PickerView.tag = 4
    }
    
    
    // API Call
    func Macros_Calculator(activitylevel: Int, height: Int, weight: Int, gender: String, age: Int, goal: String)
    {
        let headers = [
            "x-rapidapi-key": "f0125eaca0msh9b1a3d0855ae9d4p1761eajsn17059b246ad0",
            "x-rapidapi-host": "fitness-calculator.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://fitness-calculator.p.rapidapi.com/macrocalculator?activitylevel=\(activitylevel)&height=\(height)&weight=\(weight)&gender=\(gender)&age=\(age)&goal=\(goal)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {

                if let data = data {
                    // Decode the JSON data to Macros
                    let decoder = JSONDecoder()
                    do {
                        let ma = try decoder.decode(Macros.self, from: data)
                        self.protein = Int(ma.balanced.protein)
                        self.carbs = Int(ma.balanced.carbs)
                        self.fat = Int(ma.balanced.fat)
                        DispatchQueue.main.async {
                            self.showMacros(vc: self.MA_VC)
                        }
                    }
                    // If any error occurs notify the user
                    catch {
                        print(error)
                        DispatchQueue.main.async {
                            self.showError(vc: self.MA_VC)
                        }
                    }
                }
            }
        })

        dataTask.resume()

    }
    
    // Submit Button
    @IBAction func Macros_Amounts_Submit(_ sender: BounceButton)
    {
        if(MA_age_text.text == "" || MA_weight_text.text == "" || MA_goals_text.text == "" || MA_activity_text.text == "" || MA_gender_text.text == "" || MA_height_text.text == "")
        {
            emptyFields(vc: MA_VC)
        }
        else {
            let cm = Int(ft_to_cm(height: MA_height_text.text!))
            let kg = Int(lb_to_kg(lb: Int(MA_weight_text.text!)!))
            let a_level = MA_activity_text.text
            let activity_number = a_level![a_level!.startIndex]
            let activity_int = Int(String(activity_number))!
            let gender = gender_conv(gender: MA_gender_text.text!)
            let age = Int(String(MA_age_text.text!))!
            let goal = editGoals(goal: MA_goals_text.text!)
            Macros_Calculator(activitylevel: activity_int, height: Int(cm), weight: Int(kg), gender: gender, age: age, goal: goal)
        }
    }
    
    // MARK: - Conversion Functions
    
    func gender_conv(gender: String) -> String
    {
        if(gender == "Male")
        {
            return "male"
        }
        else
        {
            return "female"
        }
    }
    
    func lb_to_kg(lb: Int) -> Double
    {
        let lb_double = Double(lb)
        return lb_double / 2.205
    }
    
    func ft_to_cm(height: String) -> Double
    {
        let ft_char = height[height.startIndex]
        let ft = Double(String(ft_char))
        var cm = ft! * 30.48
        if let range = height.range(of: "'") {
            let inches_string = height[range.upperBound...]
            let inches = Double(String(inches_string))
            cm += inches! * 2.54
        }
        return cm
    }
    
    // If there are any empty fields
    func emptyFields(vc: ViewController) {
        AudioServicesPlaySystemSound(SystemSoundID(1112))
        let alert = UIAlertController(title: "Empty Fields", message: "You have not filled in all the required fields", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
        }))
        
        vc.present(alert, animated: true)
    }
    
    // Change the goals to fit the API call
    func editGoals(goal: String) -> String
    {
        switch goal {
        case "Maintain Weight":
            return "maintain"
        case "Mild Weight Loss":
            return "mildlose"
        case "Weight Loss":
            return "weightlose"
        case "Extreme Weight Loss":
            return "extremelose"
        case "Mild Weight Gain":
            return "mildgain"
        case "Weight Gain":
            return "weightgain"
        case "Extreme Weight Gain":
            return "extremegain"
        default:
            return "No Goal"
        }
    }
    
    // Popup notification for the results of the API
    func showMacros(vc: ViewController) {
        
        let alert = UIAlertController(title: "Macros Amount", message: "The ideal amount of protein you should be eating is \(protein) grams. \n The ideal amount of carbs you should be eating is \(carbs) grams. \n The ideal amount of fat you should be eating is \(fat) grams.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
            }))
        
            vc.present(alert, animated: true)
    }
    
    // Error Alert if the API does not work
    func showError(vc: ViewController) {
        
        let alert = UIAlertController(title: "Macros Amount", message: "The API for Macros Amount is not currently working, please try again later.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
            }))
        
            vc.present(alert, animated: true)
    }
    
}

extension MacrosAmountCell: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return heights.count
        case 2:
            return genders.count
        case 3:
            return activity_levels.count
        case 4:
            return goals.count
        default:
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return heights[row]
        case 2:
            return genders[row]
        case 3:
            return activity_levels[row]
        case 4:
            return goals[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            MA_height_text.text = heights[row]
            MA_height_text.resignFirstResponder()
        case 2:
            MA_gender_text.text = genders[row]
            MA_gender_text.resignFirstResponder()
        case 3:
            MA_activity_text.text = activity_levels[row]
            MA_activity_text.resignFirstResponder()
        case 4:
            MA_goals_text.text = goals[row]
            MA_goals_text.resignFirstResponder()
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// Macros Amount JSON

struct Macros: Codable {
    let balanced: Macros_Item
    let calorie: Float
    let highprotein: Macros_Item
    let lowcarbs: Macros_Item
    let lowfat: Macros_Item
}

struct Macros_Item: Codable {
    let carbs: Float
    let fat: Float
    let protein: Float
}
