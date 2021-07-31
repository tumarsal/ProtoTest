//
//  TaskViewController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit
class TaskViewController : UIScrollViewController {
    
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
            self.statusLabel.text = appointment.statusText()
            if appointment.status == .Approved {
                requireAdditionalApprove.isHidden = true
                approveButton.isHidden = true
                notApproveButton.isHidden = true
            }
            if  appointment.waitChild() {
                requireAdditionalApprove.isHidden = true
               
            }
        }
       
        if task.documents.count == 0 {
            self.docsButton.isHidden = true
        } else {
            self.docsButton.setTitle("Документы (\(task.documents.count))", for: .normal)
        }
        authorLabel.text = task.author
        availibilityLabel.text = task.responsible
        sumLabel.text = task.sum
        sumNoNdsLabel.text = task.sum_no_nds
        buyTypeLabel.text = task.buy_type
        
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
            if let appointment = self.task.getUserAppointment(userId: mainData.currentUser.id) {
                appointment.status = .Approved
               
                self.statusLabel.text = appointment.statusText()
                mainData.save()
            }
           
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
            if let appointment = self.task.getUserAppointment(userId: mainData.currentUser.id) {
                appointment.status = .NotApproved
               
                self.statusLabel.text = appointment.statusText()
                mainData.save()
            }
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in
            // self.task.status = .NotApproved

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
