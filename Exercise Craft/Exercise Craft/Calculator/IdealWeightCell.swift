//
//  IdealWeight.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/26/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit
import AudioToolbox

class IdealWeightCell: UITableViewCell {
    
    @IBOutlet var IW_height_text: UITextField!
    @IBOutlet var IW_gender_text: UITextField!
    @IBOutlet var IW_VC: ViewController!
    
    
    let heights = ["4'8", "4'9", "4'10", "4'11", "5'1", "5'2", "5'3", "5'4", "5'5", "5'6", "5'7", "5'8", "5'9", "5'11", "6'0", "6'1", "6'2", "6'3", "6'4", "6'5", "6'6"]
    
    let genders = ["Male", "Female"]
    
    var IW_height_PickerView = UIPickerView()
    var IW_gender_PickerView = UIPickerView()
    
    var ideal_weight = 0
    
    func configure() {
        
        IW_height_text.inputView = IW_height_PickerView
        IW_gender_text.inputView = IW_gender_PickerView
        
        IW_height_PickerView.delegate = self
        IW_height_PickerView.dataSource = self
        IW_gender_PickerView.delegate = self
        IW_gender_PickerView.dataSource = self
        
        IW_height_PickerView.tag = 1
        IW_gender_PickerView.tag = 2
    }
    
    // Ideal Weight API Call
    func Ideal_Weight(gender: String, height: Int){
        let headers = [
            "x-rapidapi-key": "f0125eaca0msh9b1a3d0855ae9d4p1761eajsn17059b246ad0",
            "x-rapidapi-host": "fitness-calculator.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://fitness-calculator.p.rapidapi.com/idealweight?&gender=\(gender)&height=\(height)")! as URL,
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
                    let decoder = JSONDecoder()
                    do {
                        // Decodes JSON into I_Weight
                        let iw = try decoder.decode(I_Weight.self, from: data)
                        self.ideal_weight = Int(iw.Devine*2.205)
                        DispatchQueue.main.async {
                            self.showIdealWeight(vc: self.IW_VC)
                        }
                    }
                    // If an error occurs, show an error popup
                    catch {
                        print(error)
                        DispatchQueue.main.async {
                            self.showError(vc: self.IW_VC)
                        }
                    }
                }
            }
        })

        dataTask.resume()

    }
        
    // Submit Button
    @IBAction func Ideal_Weight_Submit(_ sender: BounceButton)
    {
        if(IW_gender_text.text == "" || IW_height_text.text == "")
        {
            emptyFields(vc: IW_VC)
        }
        else {
            let cm = ft_to_cm(height: IW_height_text.text!)
            let gender = gender_conv(gender: IW_gender_text.text!)
            Ideal_Weight(gender: gender, height: Int(cm))
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
        
    // Empty Fields
    func emptyFields(vc: ViewController) {
        AudioServicesPlaySystemSound(SystemSoundID(1112))
        let alert = UIAlertController(title: "Empty Fields", message: "You have not filled in all the required fields", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
        }))
    
        vc.present(alert, animated: true)
    }

    // Alert for Ideal Weight
    func showIdealWeight(vc: ViewController) {
        let alert = UIAlertController(title: "Ideal Weight", message: "Ideal Weight for the selected height and gender is \(ideal_weight) lbs", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
        }))
    
        vc.present(alert, animated: true)
    }

    // Alert for Error
    func showError(vc: ViewController) {
        let alert = UIAlertController(title: "Macros Amount", message: "The API for Macros Amount is not currently working, please try again later.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in print ("Tapped OK")
        }))
    
        vc.present(alert, animated: true)
    }
        
}


extension IdealWeightCell: UIPickerViewDelegate, UIPickerViewDataSource {
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
            IW_height_text.text = heights[row]
            IW_height_text.resignFirstResponder()
        case 2:
            IW_gender_text.text = genders[row]
            IW_gender_text.resignFirstResponder()
        default:
            return
        }
    }
    
}


// Ideal Weight JSON

struct I_Weight: Codable {
    let Hamwi: Float
    let Devine: Float
    let Miller: Float
    let Robinson: Float
}

