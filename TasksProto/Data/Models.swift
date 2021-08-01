//
//  Models.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import SwiftyJSON

let mainData: MainDataModel = loadData()
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
func loadData() -> MainDataModel {
    let filename = getDocumentsDirectory().appendingPathComponent("output.json")
    if FileManager.default.fileExists(atPath: filename.path) {
        let data: Data
        do {
            data = try Data(contentsOf: filename)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(MainDataModel.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(MainDataModel.self):\n\(error)")
        }
    }
    let data:MainDataModel = load("data.json")
    for task in data.tasks {
        for item in task.allAppointments() {
            if let user = data.users.first(where: { ui in
                return ui.id == item.userId
            }) {
            //item.text = "\(user.first_name) \(user.last_name)"
            item.text = "\(user.first_name) \(user.last_name)"
            }
        }
    }
  
    return data
}
func load<T: JSONCreatable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

class MainDataModel:JSONModel{
    var currentUser:UserModel
    var users:[UserModel]
    var tasks:[TaskModel]
    
    required init(fromJson json: JSON) {
        let users:[UserModel] = json["users"].asArrayValue()
        
        self.users = users
        tasks = json["tasks"].asArrayValue()
        currentUser = users.first(where: { u in
            return u.selected
        }) ?? users.first!
    }
    
    func json() -> JSON {
        var json = JSON()
        json.setValue("users", users)
        json.setValue("tasks", tasks)
        return json
    }
    func save(){
        let str = self.asLineJsonString()
        let filename = getDocumentsDirectory().appendingPathComponent("output.json")

        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}

class DocumentModel:JSONModel{
    let name:String
    let filename:String
    func json() -> JSON {
        var json = JSON()
        json.setValue("name", name)
        json.setValue("filename", filename)
        return json
    }
    
    required init(fromJson json: JSON) {
        name = json["name"].stringValue
        filename = json["filename"].stringValue
    }
}
class UserModel:JSONModel{
    let id:Int
    let first_name:String
    let last_name:String
    let patronymic:String
    let login:String
    let password:String
    var selected:Bool
    init(id:Int,first_name:String,
     last_name:String,
     patronymic:String,
     login:String,
     password:String) {
        self.first_name = first_name
        self.last_name = last_name
        self.patronymic = patronymic
        self.id = id
        self.selected = false
        self.login = login
        self.password = password
    }
    
    required init(fromJson json: JSON) {
        id = json["id"].intValue
        first_name = json["first_name"].stringValue
        last_name = json["last_name"].stringValue
        patronymic = json["patronymic"].stringValue
        selected = json["selected"].bool ?? false
        login = json["login"].string ?? ""
        password = json["password"].string ?? ""
    }
    
    func json() -> JSON {
        var json = JSON()
        json.setValue("id", id)
        json.setValue("first_name", first_name)
        json.setValue("last_name", last_name)
        json.setValue("patronymic", patronymic)
        json.setValue("selected", selected)
        json.setValue("login", login)
        json.setValue("password", password)
        return json
    }
}

class TaskModel:JSONModel{
    let name:String
    let description:String
    let documents:[DocumentModel]
    var appointment:[TaskAppointmentModel]
    
    let author:String
    let sum:String
    let sum_no_nds:String
    let responsible:String
    let buy_type:String
    required init(fromJson json: JSON) {
        name = json["name"].stringValue
        description = json["description"].stringValue
        author = json["author"].stringValue
        sum_no_nds = json["sum_no_nds"].stringValue
        sum = json["sum"].stringValue
        responsible = json["responsible"].stringValue
        buy_type = json["buy_type"].stringValue
        documents = json["documents"].asArrayValue()
        appointment = json["appointment"].asArrayValue()
        
    
        
    }
    
    func statusForUser(userId:Int) -> TaskStatus {
        if let appointment = getUserAppointment(userId: userId)  {
            return appointment.status
        }
        return TaskStatus.NotApproved
    }
  
    func json() -> JSON {
        var json = JSON()
        json.setValue("name", name)
        json.setValue("description", description)
        json.setValue("documents", documents)
        json.setValue("appointment", appointment)
        
       
        return json
    }
    func allAppointments() -> [TaskAppointmentModel] {
        var out:[TaskAppointmentModel] = []
        var app:[TaskAppointmentModel] = []
        for a in self.appointment {
            app.append(a)
        }
        while app.count > 0 {
            let item = app[0]
            app.remove(at: 0)
            out.append(item)
            if let children = item.children {
                for a in  children {
                    app.append(a)
                }
            }
           
        }
        return out
    }
    func haveToShowUser(user_id:Int) -> Bool{
        var userIDs:[Int] = []
        
        var app:[TaskAppointmentModel] = []
        for a in self.appointment {
            app.append(a)
        }
        while app.count > 0 {
            let item = app[0]
            app.remove(at: 0)
            userIDs.append(item.userId)
            if let children = item.children {
                for a in  children {
                    app.append(a)
                }
            }
           
        }
        return userIDs.contains(user_id)
    }
    func getUserAppointment(userId:Int) -> TaskAppointmentModel?{
        var app:[TaskAppointmentModel] = []
        for a in self.appointment {
            app.append(a)
        }
        while app.count > 0 {
            let item = app[0]
            app.remove(at: 0)
            if item.userId == userId {
                return item
            }
            if let children = item.children {
                for a in  children {
                    app.append(a)
                }
            }
           
        }
        return nil
    }
}
enum TaskStatus:String{
    case WaitApprove = "WAIT"
    case Approved =  "APPROVED"
    case NotApproved = "NOT_APPROVED"
}

class TaskAppointmentModel:JSONModel,TreeNodeProtocol {
    let userId:Int
    var status:TaskStatus
    var children:[TaskAppointmentModel]?
  
    let limit_date:Date
    var identifier: String
    var text:String
    var isExpandable: Bool {
        return children != nil || children?.count == 0
    }
    func isDeadline() -> Bool{
        let text = limit_date.format("dd.MM.yyyy")
       return limit_date < Date()
    }
    func statusText() -> String {
        switch self.status {
        case .Approved:
           
            return "Согласован"
            
        case .WaitApprove:
            if waitChild() {
                return "Ожидает доп. согласования"
            }
            return "Ожидает согласования"
        
           
        default:
            return "Не согласован"
        }
    }
   
    
    init( userId:Int,
     status:TaskStatus,
     date:Date,
     identifier: String,
     text:String) {
        self.userId = userId
        self.status = status
        self.limit_date = date
        self.identifier = identifier
        self.text = text
        self.children = nil
    }
    required init(fromJson json: JSON) {
        userId = json["user_id"].intValue
        identifier = "\(arc4random()%UInt32.max)"
        status = json["status"].enumValue()
        children = json["children"].asArray()
        limit_date = json["limit_date"].dateValue(format: "dd.MM.yyyy")
        text = json["text"].stringValue
        
    }
    init(withIdentifier identifier: String, andChildren children: [TaskAppointmentModel]? = nil) {
        self.identifier = identifier
        self.children = children
        userId = 1
        
        status = .Approved
        
        limit_date = Date()
        text = identifier
    }
    func waitChild() -> Bool {
        if let children = self.children {
            return children.contains { w in
                w.status == .WaitApprove
            }
        }
        return false
    }
    
    func json() -> JSON {
        var json = JSON()
        json.setValue("user_id", userId)
        json.setValue("status", status)
        json.setValue("children", children)
        json.setValue("limit_date", limit_date,format:"dd.MM.yyyy")
        json.setValue("text", text)
        return json
    }
}
