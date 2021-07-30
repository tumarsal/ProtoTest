//
//  TaskViewController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit
class TaskViewController : UIViewController {
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var docsButton:UIButton!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var approveButton:UIButton!
    var task:TaskModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = task.name
        self.descriptionLabel.text = task.description
        self.statusLabel.text = task.statusText()
        if task.documents.count == 0 {
            self.docsButton.isHidden = true
        } else {
            
            self.docsButton.setTitle("Документы (\(task.documents.count))", for: .normal)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let docsView = segue.destination as? DocumentsViewController {
            docsView.task = self.task
        }
        if let docsView = segue.destination as? HistoryTreeController {
            docsView.root = self.task.appointment
        }
        if let docsView = segue.destination as? RequireUserApproveViewController {
            docsView.task = self.task
        }
        
    }
    @IBAction func approve() {
      
        let alert = UIAlertController(title: "Документ согласован?", message: "Документ согласован", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.task.status = .Approved
            self.statusLabel.text = self.task.statusText()
            mainData.save()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in
            // self.task.status = .NotApproved
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
