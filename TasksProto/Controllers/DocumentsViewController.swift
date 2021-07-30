//
//  DocumentsViewController.swift
//  TasksProto
//
//  Created by tumarsal on 27.07.2021.
//

import Foundation
import UIKit
class DocumentViewCell :UITableViewCell {
    @IBOutlet var nameLabel:UILabel!
  
    func bind(_ model:DocumentModel){
        nameLabel.text = model.name
    }
}

class DocumentsViewController : UITableViewController {
    var task:TaskModel!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.documents.count
    }
    func identifier(for f:IndexPath) -> String{
        return "cell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
        let items = task.documents
        if let c = cell as? DocumentViewCell {
           c.bind(items[indexPath.row])
       }
       return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let doc = segue.destination as? DocumentViewController,
        let selectedRow = tableView.indexPathForSelectedRow {
            doc.loadedDocument = task.documents[selectedRow.row]
        }
        
        super.prepare(for: segue, sender: sender)
    }
}
