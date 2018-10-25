//
//  SecondViewController.swift
//  ToDoTwo
//
//  Created by Joshua Lizak on 10/24/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Completed_UITableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    var completedList = [String]()
    
    /* Load ToDo List Array from UserDefaults */
    func loadCompletedList(){
        self.completedList = userDefaults.stringArray(forKey: "SavedCompletedList") ?? [String]()
        print("data READ")
        printList()
    }
    
    /* Save ToDo List to UserDefaults */
    func saveList(){
        userDefaults.set(self.completedList, forKey: "SavedCompletedList")
        print("data SAVED")
        printList()
    }
    
    func printList(){
        for element in self.completedList {
            print(element)
        }
    }
    
    /* Table View Control */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell2")
        cell.textLabel?.text = completedList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            self.completedList.remove(at: indexPath.row)
            Completed_UITableView.reloadData()
            self.saveList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Completed_UITableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompletedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCompletedList()
        Completed_UITableView.reloadData()
    }
}

