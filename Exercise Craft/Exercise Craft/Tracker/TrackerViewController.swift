//
//  TrackerViewController.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/16/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class TrackerViewController: UIViewController {
    
    @IBOutlet var TrackerTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Exercise]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TrackerTableView.delegate = self
        TrackerTableView.dataSource = self
        
        fetchExercises()
    }
    
    // Obtains the data
    func fetchExercises() {
        do {
            self.items = try context.fetch(Exercise.fetchRequest())
            DispatchQueue.main.async {
                self.TrackerTableView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }
    
    
    // Adding an Exercise
    @IBAction func addTap(_ sender: Any) {
        let alert = UIAlertController(title: "Add Exercise", message: "Enter an exercise you would like to keep track of", preferredStyle: .alert)
        
        // 6 text fields
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        
        // Placeholders
        alert.textFields![0].placeholder = "Name of Exercise"
        alert.textFields![1].placeholder = "Number of sets completed"
        alert.textFields![2].placeholder = "Number of reps completed"
        alert.textFields![3].placeholder = "Previous weights completed"
        alert.textFields![4].placeholder = "Current weight completed"
        alert.textFields![5].placeholder = "Goal weight for next time"
        
        
        let submitButton = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            // Converts each to Int64
            let setsInt: Int64? = Int64(alert.textFields![1].text!)
            let repsInt: Int64? = Int64(alert.textFields![2].text!)
            let prevInt: Int64? = Int64(alert.textFields![3].text!)
            let currentInt: Int64? = Int64(alert.textFields![4].text!)
            let nextInt: Int64? = Int64(alert.textFields![5].text!)
            
            // Creates a new Exercise with the given data
            let newExercise = Exercise(context: self.context)
            newExercise.name = alert.textFields![0].text
            newExercise.sets = setsInt ?? 0
            newExercise.reps = repsInt ?? 0
            newExercise.prev = prevInt ?? 0
            newExercise.current = currentInt ?? 0
            newExercise.next = nextInt ?? 0
            
            // If the name/sets/reps fields are not filled in
            if(newExercise.name == "" || newExercise.sets == 0 || newExercise.reps == 0)
            {
                AudioServicesPlaySystemSound(SystemSoundID(1112))
                let empty = UIAlertController(title: "Empty Fields", message: "You have not entered in a name, number of sets, or number of reps.", preferredStyle: .alert)

                    empty.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    }))
                
                self.present(empty, animated: true)
                
                // Delete the Invalid Exercise Object
                self.context.delete(newExercise)
                
                // Update the new database
                do {
                    try self.context.save()
                }
                catch {
                    
                }
                
                // Obtain the Exercises again
                self.fetchExercises()
            }
            // If the details were all entered in successfully
            else
            {
                // Add the new exercise to the database
                do {
                    try self.context.save()
                }
                catch {
                    print(error)
                }
                // Reload the data
                self.fetchExercises()
            }
        }
        
        // Cancel button
        alert.addAction(submitButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in print ("Tapped Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension TrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tracker", for: indexPath) as! ExerciseCell
        
        let exercise = self.items![indexPath.row]
        
        cell.name.text = exercise.name
        cell.sets.text = String(exercise.sets) + " sets"
        cell.reps.text = String(exercise.reps) + " reps"
        cell.prev.text = String(exercise.prev) + " lbs"
        cell.current.text = String(exercise.current) + " lbs"
        cell.nex.text = String(exercise.next) + " lbs"
        
        return cell
    }
    
    // Edit Function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Exercise", message: "Edit Exercise", preferredStyle: .alert)
        
        // 6 text fields
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        
        // Obtains data about the current exercise object they want to edit
        alert.textFields![0].text = exercise.name
        alert.textFields![1].text = String(exercise.sets)
        alert.textFields![2].text = String(exercise.reps)
        alert.textFields![3].text = String(exercise.prev)
        alert.textFields![4].text = String(exercise.current)
        alert.textFields![5].text = String(exercise.next)
        
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Converts data to Int64
            let setsInt: Int64? = Int64(alert.textFields![1].text!)
            let repsInt: Int64? = Int64(alert.textFields![2].text!)
            let prevInt: Int64? = Int64(alert.textFields![3].text!)
            let currentInt: Int64? = Int64(alert.textFields![4].text!)
            let nextInt: Int64? = Int64(alert.textFields![5].text!)
            
            // Sets the new data
            let newExercise = Exercise(context: self.context)
            newExercise.name = alert.textFields![0].text
            newExercise.sets = setsInt ?? 0
            newExercise.reps = repsInt ?? 0
            newExercise.prev = prevInt ?? 0
            newExercise.current = currentInt ?? 0
            newExercise.next = nextInt ?? 0
            
            // If the users enters incorrect data
            if(newExercise.name == "" || newExercise.sets == 0 || newExercise.reps == 0)
            {
                let empty = UIAlertController(title: "Empty Fields", message: "You have not entered in a correct name, number of sets, or number of reps.", preferredStyle: .alert)

                empty.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    }))
                
                self.present(empty, animated: true)
                self.context.delete(newExercise)
            }
            // Deletes the duplicate data
            else {
                self.context.delete(exercise)
                self.items![indexPath.row] = newExercise
                do {
                    try self.context.save()
                }
                catch {
                    print("Error")
                }
                self.fetchExercises()
                }
        }
        
        // Cancel button
        alert.addAction(saveButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in print ("Tapped Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            let exercisetoRemove = self.items![indexPath.row]
            
            self.context.delete(exercisetoRemove)

            do {
                try self.context.save()
            }
            catch {
                print("Error")
            }
            self.fetchExercises()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
