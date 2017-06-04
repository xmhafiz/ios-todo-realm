//
//  ViewController.swift
//  TodoRealm
//
//  Created by Hafiz on 04/06/2017.
//  Copyright © 2017 Hafiz. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo Apps"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getAllTask()
    }
    
    func getAllTask() {
        
        let realm = try! Realm()
        let data = realm.objects(Task.self) // query: get all Task
        print(tasks)
        
        tasks = Array(data)
        
        tableView.reloadData()

    }

    @IBAction func addButtonHandler(_ sender: Any) {
        
        guard textField.text != "" else {
            return
        }
        
        // create object
        let newTask = Task()
        newTask.name = textField.text!
        
        let realm = try! Realm() // create instance realm
        try! realm.write {
            realm.add(newTask)
        }
        
        textField.text = ""
        getAllTask()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")!
     
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        if task.completed {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        let realm = try! Realm() // create instance realm
        try! realm.write {
            task.completed = !task.completed // update this field
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleting..")
            
            let task = tasks[indexPath.row]
            // delete from realm
            let realm = try! Realm() // create instance realm
            try! realm.write {
                realm.delete(task)
            }
            
            // delete from array
            tasks.remove(at: indexPath.row)
            
            // remove a row from table instead of reload all
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}




