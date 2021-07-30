//
//  UsersController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit
class UserViewCell :UITableViewCell {
    @IBOutlet var firstNameLabel:UILabel!
    @IBOutlet var lastNameLabel:UILabel!
    @IBOutlet var patronymicLabel:UILabel!
    
    func bind(_ model:UserModel){
        firstNameLabel.text = model.first_name
        lastNameLabel.text = model.last_name
        patronymicLabel.text = model.patronymic
    }
}
class UsersController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainData.users.count
    }
    func identifier(for f:IndexPath) -> String{
                return "cell"
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             print("Deleted")
             mainData.users.remove(at: indexPath.row)
             self.tableView.beginUpdates()
             self.tableView.deleteRows(at: [indexPath], with: .automatic)
             self.tableView.endUpdates()
          }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
        let items = mainData.users
        if let c = cell as? UserViewCell {
           c.bind(items[indexPath.row])
       }
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = mainData.users
        for u in users {
            u.selected = false
        }
        let user =  users[indexPath.row]
        user.selected = true
        mainData.currentUser = user
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}
