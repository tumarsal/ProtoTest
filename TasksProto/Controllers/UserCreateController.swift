//
//  UserCreateController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit
class UserCreateController : UIViewController {
    @IBOutlet var first_name:UITextField!
    @IBOutlet var  last_name:UITextField!
    @IBOutlet var  patronymic:UITextField!
    @IBOutlet var  login:UITextField!
    @IBOutlet var  password:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func save() {
        let maxUserIdUser = mainData.users.max { u1, u2 in
            return u1.id < u2.id
        }
        mainData.users.forEach { item in
            item.selected = false
        }
        
        let user = UserModel(id: (maxUserIdUser?.id ?? 0) + 1,
                             first_name: first_name.text ?? "",
                             last_name: last_name.text ?? "",
                             patronymic: patronymic.text ?? "",
                             login: login.text ?? "",
                             password:  password.text ?? "")
        user.selected = true
        mainData.users.append(user)
        mainData.save()
        self.navigationController?.popViewController(animated: true)
    }
}
