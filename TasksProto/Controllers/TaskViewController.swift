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
    @IBOutlet var notApproveButton:UIButton!
    
    @IBOutlet var requireAdditionalApprove:UIButton!
    
    @IBOutlet var authorLabel:UILabel!
    @IBOutlet var availibilityLabel:UILabel!
    @IBOutlet var sumLabel:UILabel!
    @IBOutlet var sumNoNdsLabel:UILabel!
    @IBOutlet var buyTypeLabel:UILabel!
    
    var task:TaskModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = task.name
        self.descriptionLabel.text = task.description
        if let appointment = task.getUserAppointment(userId: mainData.currentUser.id) {
            self.statusLabel.text = appointment.status.statusText()
            if appointment.status == .Approved {
                requireAdditionalApprove.isHidden = true
                approveButton.isHidden = true
                notApproveButton.isHidden = true
            }
        }
       
        if task.documents.count == 0 {
            self.docsButton.isHidden = true
        } else {
            self.docsButton.setTitle("Документы (\(task.documents.count))", for: .normal)
        }
        authorLabel.text = task.author
        availibilityLabel.text = task.author
        sumLabel.text = task.author
        sumNoNdsLabel.text = task.author
        buyTypeLabel.text = task.author
        
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
        let alert = UIAlertController(title: "Соглосование документа", message: "Согласовать документ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.task.getUserAppointment(userId: mainData.currentUser.id)?.status = .Approved
           
            self.statusLabel.text = TaskStatus.Approved.statusText()
            mainData.save()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in
            // self.task.status = .NotApproved
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func notApprove(){
        let alert = UIAlertController(title: "Соглосование документа",
                                      message: "Отказать в соглосовании?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.task.getUserAppointment(userId: mainData.currentUser.id)?.status = .NotApproved
           
            self.statusLabel.text = TaskStatus.NotApproved.statusText()
            mainData.save()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in
            // self.task.status = .NotApproved

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
