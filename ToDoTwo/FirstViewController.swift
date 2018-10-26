//
//  FirstViewController.swift
//  ToDoTwo
//
//  Created by Joshua Lizak on 10/24/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ToDo_UITableView: UITableView!
    @IBAction func newTaskButton(_ sender: Any) {
        newTaskDialogue()
        
    }
    
    let userDefaults = UserDefaults.standard
    var toDoList = [String]()
    
    
    /* Load ToDo List Array from UserDefaults */
    func loadToDoList(){
        self.toDoList = userDefaults.stringArray(forKey: "SavedToDoList") ?? [String]()
        print("data READ")
        printList()
    }
    
    /* Save ToDo List to UserDefaults */
    func saveList(){
        userDefaults.set(self.toDoList, forKey: "SavedToDoList")
        print("data SAVED")
        printList()
    }
    
    func printList(){
        for element in self.toDoList {
            print(element)
        }
    }
    
    /* Move Completed Tasks */
    func moveTask(taskName: String){
        var completedList = userDefaults.stringArray(forKey: "SavedCompletedList") ?? [String]()
        completedList.append(taskName)
        userDefaults.set(completedList, forKey: "SavedCompletedList")
    }
    
    /* Table View Control */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = toDoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //            self.moveTask(taskName: toDoList[indexPath.row])
            self.toDoList.remove(at: indexPath.row)
            ToDo_UITableView.reloadData()
            self.saveList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskSelectedDialogue(taskName: toDoList[indexPath.row], indexPath: indexPath )
        tableView.deselectRow(at: indexPath, animated: true)
        self.ToDo_UITableView.reloadData()
    }
    
    /* Task Selected Dialogue */
    func taskSelectedDialogue (taskName: String, indexPath: IndexPath  ){
        let alertController = UIAlertController(title: taskName, message: "Change Task Name or Complete It.", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit Task", style: .default) { (_) in
            self.editTaskDialogue(originalTask: self.toDoList[indexPath.row], indexPath: indexPath)
            self.ToDo_UITableView.reloadData()
            self.saveList()
        }
        
        let completeAction = UIAlertAction(title: "Complete Task", style: .default) { (_) in
            self.moveTask(taskName: taskName)
            self.toDoList.remove(at: indexPath.row)
            self.ToDo_UITableView.reloadData()
            self.saveList()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(editAction)
        alertController.addAction(completeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /* New Task Dialogue */
    func newTaskDialogue(){
        let alertController = UIAlertController(title: "New Task", message: "Enter name of new task", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let newTask = (alertController.textFields?[0].text)
            if newTask?.count == 0 {
                self.newTaskDialogue()
            } else {
                self.toDoList.append(newTask!)
                self.ToDo_UITableView.reloadData()
                self.saveList()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Task"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* Edit Task Dialogue */
    func editTaskDialogue( originalTask: String, indexPath: IndexPath ){
        let alertController = UIAlertController(title: "Edit Task", message: "Change Task Name", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let newTask = (alertController.textFields?[0].text)
            if newTask?.count == 0 {
                self.editTaskDialogue(originalTask: originalTask, indexPath: indexPath)
            } else {
                self.toDoList[indexPath.row] = newTask!
                self.ToDo_UITableView.reloadData()
                self.saveList()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = originalTask
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToDoList()
    }
    
}

