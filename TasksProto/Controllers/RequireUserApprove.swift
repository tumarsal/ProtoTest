//
//  RequireUserApprove.swift
//  TasksProto
//
//  Created by tumarsal on 28.07.2021.
//

import Foundation
import UIKit
class RequireUserApproveViewController: UITableViewController {
    var task:TaskModel!
    var users:[UserModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
        users = mainData.users.filter({ um in
            return !self.task.haveToShowUser(user_id: um.id)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func identifier(for f:IndexPath) -> String{
                return "cell"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(for: indexPath), for: indexPath)
        let items = users
        if let c = cell as? UITableViewCell {
            let item = items[indexPath.row]
            c.textLabel?.text = "\(item.first_name) \(item.last_name)"
          // c.bind(items[indexPath.row])
       }
       return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        /*
        let myDatePicker: UIDatePicker = UIDatePicker()
             // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)

        let alertController = UIAlertController(title: "", message: nil, preferredStyle:.alert)
             alertController.view.addSubview(myDatePicker)
       
        let somethingAction = UIAlertAction(title: "Ok", style: .default) { ac in
            if let at =  self.task.getUserAppointment(userId: mainData.currentUser.id) {
                let ta = TaskAppointmentModel.init(userId: user.id, status: .NotApproved, date: myDatePicker.date, identifier: "\(user.first_name) \(user.last_name)", text: "\(user.first_name) \(user.last_name)")
                if at.children == nil{
                    at.children = [ta]
                } else{
                    at.children?.append(ta)
                }
            }
            
        }
      
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             alertController.addAction(somethingAction)
             alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
 */
        self.showDatePicker { success, date in
            if success {
                let ta = TaskAppointmentModel.init(userId: user.id, status: .WaitApprove,
                                                   date: date, identifier: "\(user.first_name) \(user.last_name)", text: "\(user.first_name) \(user.last_name)")
                if let at =  self.task.getUserAppointment(userId: mainData.currentUser.id) {
                    if at.children == nil{
                        at.children = [ta]
                    } else{
                        at.children?.append(ta)
                    }
                    self.dismiss(animated: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
}
typealias DatePickerHandler = (_ success: Bool, _ date:Date) -> Void
typealias TimePickerHandler = (_ success: Bool, _ date:Date) -> Void
extension UIViewController{

func showDatePicker(completionHandler: @escaping DatePickerHandler){
    let vc = UIViewController()
    vc.preferredContentSize = CGSize(width: 250,height: 300)
    let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: 300))
    pickerView.datePickerMode = UIDatePicker.Mode.date
    if #available(iOS 13.4, *) {
        pickerView.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
     vc.view.addSubview(pickerView)
    NSLayoutConstraint.activate([
        pickerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor,constant: 8),
        pickerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor,constant: 8),
        pickerView.topAnchor.constraint(equalTo: vc.view.topAnchor,constant: 8),
        pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor,constant: 8),
    ])

       let editRadiusAlert = UIAlertController(title: "Select Date", message: "", preferredStyle: UIAlertController.Style.actionSheet)
       editRadiusAlert.setValue(vc, forKey: "contentViewController")
       editRadiusAlert.addAction(UIAlertAction(title: "Select", style: .default, handler: {action in
        completionHandler(true,pickerView.date)
       }))
       editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            completionHandler(false,Date())
       }))
       self.present(editRadiusAlert, animated: true)
}
func showTimePicker(completionHandler: @escaping TimePickerHandler){
    let vc = UIViewController()
    vc.preferredContentSize = CGSize(width: 250,height: 300)
    let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: 300))
    

    pickerView.datePickerMode = UIDatePicker.Mode.time
    if #available(iOS 13.4, *) {
        pickerView.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
    vc.view.addSubview(pickerView)
    NSLayoutConstraint.activate([
        pickerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor,constant: 8),
        pickerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor,constant: 8),
        pickerView.topAnchor.constraint(equalTo: vc.view.topAnchor,constant: 8),
        pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor,constant: 8),
    ])
    

    let editRadiusAlert = UIAlertController(title: "Select Time", message: "", preferredStyle: UIAlertController.Style.actionSheet)
       editRadiusAlert.setValue(vc, forKey: "contentViewController")
       editRadiusAlert.addAction(UIAlertAction(title: "Select", style: .default, handler: {action in
            completionHandler(true,pickerView.date)
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
             completionHandler(false,Date())
        }))
    
    self.present(editRadiusAlert, animated: true)
}

}
