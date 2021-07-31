//
//  TasksViewController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit

class TaskViewCell :UITableViewCell {
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var limitDateLabel:UILabel!
    
    func bind(_ model:TaskModel){
        nameLabel.text = model.name
        if model.isDeadline() {
            statusLabel.text = "Просрочено"
            statusLabel.textColor = UIColor.red
            
        } else {
            let userId = mainData.currentUser.id;
          
            if let appointment = model.getUserAppointment(userId: userId){
                let status = appointment.status
                statusLabel.text = appointment.statusText()
                switch status {
                case .Approved:
                    statusLabel.textColor = UIColor.green
                case .NotApproved:
                    statusLabel.textColor = hexStringToUIColor(hex: "#fcc41c")
                case .WaitApprove:
                    statusLabel.textColor = hexStringToUIColor(hex:"#fcc41c")
               
                    
                }
            }
        }
        
        limitDateLabel.text = model.limit_date.format("dd.MM.yyyy")
    }
}

class TasksController : UITableViewController {
    var tasks:[TaskModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasks = mainData.tasks.filter({ t in
            return t.haveToShowUser(user_id: mainData.currentUser.id)
        })
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func identifier(for f:IndexPath) -> String{
                return "cell"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let taskView = segue.destination as? TaskViewController,
           let indexRow = self.tableView.indexPathForSelectedRow{
            taskView.task = tasks[indexRow.row]
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
        let items = tasks
        if let c = cell as? TaskViewCell {
           c.bind(items[indexPath.row])
       }
       return cell
    }
    @IBAction func showCurrentUser(){
        let user = mainData.currentUser
        let alert = UIAlertController(title: "Текущий пользователь", message: "\(user.first_name) \(user.last_name)  \(user.patronymic) (\(user.login))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
