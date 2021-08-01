//
//  TaskHistoryController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit



class HistoryItemViewCell: UITableViewCell {
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var patronymicLabel:UILabel!
    
    func bind(_ model:TaskModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
       
    }
}

class TaskHistoryController : UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainData.tasks.count
    }
    func identifier(for f:IndexPath) -> String{
        return "cell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
        let items = mainData.tasks
        if let c = cell as? TaskViewCell {
           c.bind(items[indexPath.row])
       }
       return cell
    }
}

