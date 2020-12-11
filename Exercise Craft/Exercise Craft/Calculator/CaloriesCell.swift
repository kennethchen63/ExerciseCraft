//
//  CaloriesCell.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/26/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit
import AudioToolbox

class CaloriesCell: UITableViewCell {
    
    @IBOutlet var DC_height_text: UITextField!
    @IBOutlet var DC_gender_text: UITextField!
    @IBOutlet var DC_weight_text:UITextField!
    @IBOutlet var DC_age_text:UITextField!
    @IBOutlet var DC_VC: ViewController!
    
    let heights = ["4'8", "4'9", "4'10", "4'11", "5'1", "5'2", "5'3", "5'4", "5'5", "5'6", "5'7", "5'8", "5'9", "5'11", "6'0", "6'1", "6'2", "6'3", "6'4", "6'5", "6'6"]
    
    let genders = ["Male", "Female"]
    
    var DC_height_PickerView = UIPickerView()
    var DC_gender_PickerView = UIPickerView()
    
    var calories = 0
    
    func configure() {
        
        DC_height_text.inputView = DC_height_PickerView
        DC_gender_text.inputView = DC_gender_PickerView
        
        DC_height_PickerView.delegate = self
        DC_height_PickerView.dataSource = self
        DC_gender_PickerView.delegate = self
        DC_gender_PickerView.dataSource = self
        
        DC_height_PickerView.tag = 1
        DC_gender_PickerView.tag = 2
    }
 
    // Calories API call
    func Daily_Calories_Calculator(height: Int, gender: String, weight: Int, age: Int)
    {
        let headers = [
            "x-rapidapi-key": "f0125eaca0msh9b1a3d0855ae9d4p1761eajsn17059b246ad0",
            "x-rapidapi-host": "fitness-calculator.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://fitness-calculator.p.rapidapi.com/dailycalory?heigth=\(height)&age=\(age)&gender=\(gender)&weigth=\(weight)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                // Converts the JSON data to a displayable notification
                if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any] {
                        if let c = dictionary["data"] {
                            if let ca = c as? [String:Any] {
                                if let cal = ca["Exercise 4-5 times/week"] {
                                    self.calories = (cal as AnyObject).intValue
                                    DispatchQueue.main.async {
                                        self.showCalories(vc: self.DC_VC)
                                    }
                                }
                            }
                        }
                    }
                }
                // If the API is not working
                catch {
                    DispatchQueue.main.async {
                        self.showError(vc: self.DC_VC)
                    }
                    print(error)
                    }
                }
            }
        })

        dataTask.resume()

    }
    
    @IBAction func Daily_Calories_Submit(_ sender: BounceButton)
    {
        if( DC_height_text.text == "" || DC_gender_text.text == "" || DC_weight_text.text == "" || DC_age_text.text == "")
        {
            emptyFields(vc: DC_VC)
        }
        else {
            let cm = Int(ft_to_cm(height: DC_height_text.text!))
            let kg = Int(lb_to_kg(lb: Int(DC_weight_text.text!)!))
            let gender = gender_conv(gender: DC_gender_text.text!)
            let age = Int(String(DC_age_text.text!))!
            Daily_Calories_Calculator(height: cm, gender: gender, weight: kg, age: age)
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
    
    // If there is any empty fields
    func emptyFields(vc: ViewController) {
        AudioServicesPlaySystemSound(SystemSoundID(1112))
        let alert = UIAlertController(title: "Empty Fields", message: "You have not filled in all the required fields", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
        }))
        
        vc.present(alert, animated: true)
    }
    
    // Alert popup for calories
    func showCalories(vc: ViewController) {
        
        let alert = UIAlertController(title: "Daily Calories", message: "The ideal amount of calories you should be eating is \(calories) calories.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
            }))
        
            vc.present(alert, animated: true)
    }
    
    // Error popup if the API does not work
    func showError(vc: ViewController) {
        
        let alert = UIAlertController(title: "Daily Calories", message: "The API for Daily Calories is not currently working, please try again later.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
            }))
        
            vc.present(alert, animated: true)
    }
    
}

extension CaloriesCell: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         switch pickerView.tag {
         case 1:
             return heights.count
         case 2:
             return genders.count
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
         default:
             return "Data not found."
         }
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         switch pickerView.tag {
         case 1:
             DC_height_text.text = heights[row]
             DC_height_text.resignFirstResponder()
         case 2:
             DC_gender_text.text = genders[row]
             DC_gender_text.resignFirstResponder()
         default:
             return
         }
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
}

struct Calories: Codable {
    let BMR: Double
    
}
