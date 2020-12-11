//
//  ExercisesViewController.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/26/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit

class ExercisesViewController: ViewController {

    @IBOutlet var ExerciseTableView: UITableView!
    
    var imagecell: ExerciseImageCell?
    var namecell: ExerciseNameCell?
    
    var exercise = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ExerciseTableView.delegate = self
        ExerciseTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // Function to determine which picture to display
    func load_pic(exercise: String){
        if(exercise == "Abs")
        {
            imagecell?.BodyImage.image = UIImage(named: "Cable Crunch")
        }
        else if(exercise == "Arms")
        {
            imagecell?.BodyImage.image = UIImage(named: "Curls")
        }
        else if(exercise == "Back")
        {
            imagecell?.BodyImage.image = UIImage(named: "Deadlift")
        }
        else if(exercise == "Buttocks")
        {
            imagecell?.BodyImage.image = UIImage(named: "Squats")
        }
        else if(exercise == "Cardio Heart")
        {
            imagecell?.BodyImage.image = UIImage(named: "Treadmill")
        }
        else if(exercise == "Chest")
        {
            imagecell?.BodyImage.image = UIImage(named: "Bench Press")
        }
        else if(exercise == "Hips")
        {
            imagecell?.BodyImage.image = UIImage(named: "Hip Thrust")
        }
        else if(exercise == "Legs")
        {
            imagecell?.BodyImage.image = UIImage(named: "Leg Press")
        }
        else if(exercise == "Shoulders")
        {
            imagecell?.BodyImage.image = UIImage(named: "Shoulder Press")
        }
    }
    
    // Sets the selected body part the user selected
    func load_name(name: String) {
        if(name == "Abs")
        {
            namecell?.ExericseName.text = "Cable Crunch"
        }
        else if(name == "Arms")
        {
            namecell?.ExericseName.text = "Curls"
        }
        else if(name == "Back")
        {
            namecell?.ExericseName.text = "Deadlift"
        }
        else if(name == "Buttocks")
        {
            namecell?.ExericseName.text = "Squats"
        }
        else if(name == "Cardio Heart")
        {
            namecell?.ExericseName.text = "Treadmill"
        }
        else if(name == "Chest")
        {
            namecell?.ExericseName.text = "Bench Press"
        }
        else if(name == "Hips")
        {
            namecell?.ExericseName.text = "Hip Thrust"
        }
        else if(name == "Legs")
        {
            namecell?.ExericseName.text = "Leg Press"
        }
        else if(name == "Shoulders")
        {
            namecell?.ExericseName.text = "Shoulder Press"
        }
    }

}

extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 525
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseBody", for: indexPath) as! ExerciseImageCell
            imagecell = cell
            self.load_pic(exercise: self.exercise)
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyPart", for: indexPath) as! SelectedPartCell
            cell.SelectedBodyPart.text = self.exercise
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercises", for: indexPath) as! ExerciseNameCell
        namecell = cell
        self.load_name(name: self.exercise)
        return cell
    }
}
