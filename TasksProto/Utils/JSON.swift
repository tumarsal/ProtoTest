import SwiftyJSON
import Foundation

public protocol JSONCreatable :Decodable{
    init(fromJson json: JSON)
}

extension JSONCreatable {
    init(data: [String: Any]) {
        self.init(fromJson: JSON(data))
    }
    init(parseJSON: String) {
        self.init(fromJson: JSON(parseJSON: parseJSON))
    }
    public init(from decoder: Decoder) throws {
        self.init(fromJson: try JSON(from: decoder))
    }

}

protocol IList {
    var total_count: Int? { set get }
    var count: Int? { set get }
}

open class RestList<T>: JSONModel, IList where T: JSONModel {

    public var count: Int?
    public let offset: Int?
    public let items: [T]
    public var total_count: Int?


    public func json() -> JSON {
        var json: [String: Any] = ["items": items.json()]
        if let count = count {
            json["count"] = count
        }
        if let offset = offset {
            json["offset"] = offset
        }
        if let total_count = total_count {
            json["total_count"] = total_count
        }
        return JSON(json)
    }


    required public init(fromJson json: JSON) {
        if let array = json.array {
            self.count = array.count
            self.offset = nil
            self.items = json.asArrayValue()
            self.total_count = nil
        } else {
            self.count = json["count"].int
            self.offset = json["offset"].int
            self.total_count = json["total_count"].int
            self.items = json["items"].asArrayValue()
        }
    }

    required public init(fromJson json: JSON, total_count: Int?) {
        if let array = json.array {
            self.count = array.count
            self.offset = nil
            self.items = json.asArrayValue()
            self.total_count = total_count
        } else {
            self.count = json["count"].int
            self.offset = json["offset"].int
            self.total_count = json["total_count"].int ?? total_count
            self.items = json["items"].asArrayValue()
        }
    }

    init() {
        count = nil
        offset = nil
        total_count = nil
        items = []
    }

    init(_ items: [T]) {
        count = nil
        offset = nil
        total_count = nil
        self.items = items
    }

    init(forResource: String, withExtension: String) {
        self.offset = nil
        self.total_count = nil
        if let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) {
            if let text = FileUtil.loadTextFrom(url: url) {
                let items: [T] = JSON(parseJSON: text).asArrayValue()
                count = items.count
                self.items = items
            } else {
                items = []
                self.count = 0
            }
        } else {
            items = []
            self.count = 0
        }
    }
}

protocol DateParcerProtocol {
    func parce(value: JSON) -> Date?
}

class DateParcer: DateParcerProtocol {

    public func parce(value: JSON) -> Date? {
        if let timeInt = value.double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }

        if let timeStr = value.string {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
        }
        return nil
    }

}

extension JSON {
    var  urlValue:URL {
        get {
            return URL.init(string: self.stringValue)!
        }
    }
    public static func empty()-> JSON{
        return JSON(parseJSON: "{}")
    }
    
    public mutating func setValue(_ key:String,_ value:String){
        self[key] = JSON(value)
    }
    public mutating func setValue(_ key:String,_ value:Int64?){
        if let value = value {
            self[key] = JSON(value)
        }
    }
    
    public mutating func setValue(_ key:String,_ value:Bool){
        self[key] = JSON(value)
    }
    public mutating func setValue(_ key:String,_ value:Int){
        self[key] = JSON(value)
    }
    public mutating func setValue(_ key:String,_ value:Double){
        self[key] = JSON(value)
    }
    public mutating func setValue(_ key:String,_ value:JSONModel){
        self[key] = value.json()
    }
    public mutating func setValue(_ key:String,_ value:JSONModel?){
        if let value = value {
            self[key] = value.json()
        }
    }
    public mutating func setValue<T>(_ key:String,_ value:[T]?) where T:JSONModel {
        if let value = value {
            self[key] = JSON(value.json())
        }
    }
    public mutating func setValue(_ key:String,_ value:Date){
        self[key] = JSON(value.timeIntervalSince1970Long)
    }
    public mutating func setValue(_ key:String,_ value:Date,format:String){
        self[key] = JSON(value.format(format))
    }
    public mutating func setValue<T>(_ key:String,_ value:T) where T:RawRepresentable {
        self[key] = JSON(value.rawValue)
    }
    public mutating func setValue(_ key:String,_ value:Date?){
        if let value = value {
            self[key] = JSON(value.timeIntervalSince1970Long)
        }
    }
    public mutating func setValue(_ key:String,_ value:Int?){
        if let value = value {
            self[key] = JSON(value)
        }
    }
    public mutating func setValue(_ key:String,_ value:String?){
        if let value = value {
            self[key] = JSON(value)
        }
    }
    public mutating func setValue(_ key:String,_ value:Bool?){
        if let value = value {
            self[key] = JSON(value)
        }
    }
    func enumValue<T: RawRepresentable>() -> T where T.RawValue == String {
        return T.init(rawValue: self.stringValue)!

    }

    func `enum`<T: RawRepresentable>() -> T? where T.RawValue == UInt8 {
        if let sv = self.uInt8 {

            return T(rawValue: sv)
        }
        return nil

    }
    func `enum`<T: RawRepresentable>() -> T? where T.RawValue == String {
        if let sv = self.string {

            return T(rawValue: sv)
        }
        return nil

    }
    
    func enumValue<T: RawRepresentable>() -> T where T.RawValue == Int {
        return T(rawValue: self.intValue)!
    }
    func `enum`<T: RawRepresentable>() -> T? where T.RawValue == Int {
        if let sv = self.int {

            return T(rawValue: sv)
        }
        return nil
    }

    func enumValue<T: RawRepresentable>() -> T where T.RawValue == UInt16 {
        return T(rawValue: UInt16(self.intValue))!
    }
    func enumValue<T: RawRepresentable>() -> T where T.RawValue == UInt8 {
        return T(rawValue: UInt8(self.intValue))!
    }

    func `enum`<T: RawRepresentable>() -> T? where T.RawValue == UInt16 {
        if self.int != nil {

            return T(rawValue: UInt16(self.intValue))
        }
        return nil
    }

    func dateValue(_ parcer: DateParcerProtocol) -> Date {
        return parcer.parce(value: self) ?? Date()
    }

    func date(_ parcer: DateParcerProtocol) -> Date? {
        return parcer.parce(value: self)
    }

    public var date: Date? {
        get {
            if let long = self.int64 {
                return Date(timeIntervalSince1970Long: long)
            }
            return nil
        }
    }

    public var dateValue: Date {
        get {
            if let long = self.int64 {
                return Date(timeIntervalSince1970Long: long )
            }
            return Date(timeIntervalSince1970: 0)
        }
    }
    public func dateValue(format:String) -> Date {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        let value = self.stringValue
        let date = dateFormatter.date(from: value)!
        let outTest = date.format(format)
        return date
    }
    public func asObject<T>() -> T? where T: JSONCreatable {
        if isEmpty {
            return nil
        }
        return T(fromJson: self)
    }

    public func asObjectValue<T>() -> T where T: JSONCreatable {
        if isEmpty {
            fatalErrorIfDebug()
        }
        return T(fromJson: self)
    }

    func asArrayValue<T>() -> [T] where T: JSONCreatable {
        return array?.map { json in T(fromJson: json) } ?? []
    }

    func asMapValue<T>() -> [String: T] where T: JSONCreatable {
        var outMap: [String: T] = [:]
        if let map = self.dictionary {
            for item in map {
                outMap[item.key] = T(fromJson: item.value)
            }
        }
        return outMap
    }

    func asMap<T>() -> [String: T]? where T: JSONCreatable {

        if let map = self.dictionary {
            if map.count > 0 {
                var outMap: [String: T] = [:]
                for item in map {
                    outMap[item.key] = T(fromJson: item.value)
                }
                return outMap
            }
        }
        return nil
    }

    func asArray<T>() -> [T] where T: JSONCreatable {
        return array?.map { json in T(fromJson: json) } ?? []
    }

    func intArray() -> [Int]? {
        return array?.map { json in json.intValue } ?? nil
    }
    func stringArray() -> [String]? {
        return array?.map { json in json.stringValue } ?? nil
    }
    func stringArrayValue() -> [String]{
        return array?.map { json in json.stringValue } ?? []
    }

    func intArrayValue() -> [Int] {
        return array?.map { json in json.intValue } ?? []
    }

}

public protocol JSONModel: JSONCreatable,Encodable {

    func json() -> JSON
    

}
extension JSONModel {
    public func encode(to encoder: Encoder) throws {
        try JSON.init(self.json()).encode(to: encoder)
    }
}
extension Dictionary where Key == String, Value: JSONModel {

    func json() -> JSON {
        var json = JSON()
        for item in self {
            json[item.key] = item.value.json()
        }
        return json
    }

}

extension Dictionary where Key == String, Value == Any {

    mutating func add(_ items: [String: Any]) -> [String: Any] {
        for item in items {
            self[item.key] = item.value
        }
        return self
    }

}

public extension Array where Element: JSONModel {

    public func json() -> JSON {
        return JSON(self.map({ (m) -> JSON in
            return m.json()
        }))
    }

    public func asLineJsonString() -> String {
        return self.json().asLineJsonString()
    }

    public func asJsonString() -> String {
        return self.json().rawString()!
    }

}

public extension JSON {

    public func asLineJsonString() -> String {
        if let jsonString = self.rawString() {
            let lines = jsonString.split(separator: "\n")
            let trimLines = lines.map { (item) -> String in
                return item.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                .replace(target: " : ", withString: ":")
            }.joined()
            return trimLines
        } else {
            return ""
        }
    }
}

public extension Dictionary where Key == String {

    func asLineJsonString() -> String {
        let lines = ( self.json().rawString() ?? "" ).split(separator: "\n")
        let trimLines = lines.map { (s) -> String in
            return s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replace(target: " : ", withString: ":")
        }.joined()
        return trimLines
     
    }
    func json() -> JSON {
        var json = JSON()
        for item in self {
            json[item.key] = JSON(item.value)
        }
        return json
    }
}

public extension JSONModel {
    
    func asJsonString() -> String {
        return self.json().rawString() ?? ""
    }

    func jsonstring() -> String {
        let json = self.json()
        return json.asLineJsonString()
    }

    func asLineJsonString() -> String {
        let json = self.json() 
        return json.asLineJsonString()
    }

    func asJsonObject() -> JSON {
        return self.json()
    }

    func data(using: String.Encoding = String.Encoding.utf8) -> Data {
        return self.asLineJsonString().data(using: using)!
    }

    func asAnswer() -> Data {
        return Answer(data: self).data()
    }

}

extension Data {


}

public enum ErrorType: Int {
    
    // Incorrect input data.
    case incorrectInputData = 1

    // Server error.
    case serverError = 2
    
    // Requested data not found.
    case dataNotFound = 3
    
    // Object to create already exists.
    case objectExists = 4
    
    // Uses for cache. This code is not used currently.
    case lastModified = 5
    
    // Wrong password.
    case incorrectPassword = 6
    
    // Wrong code.
    case invalidCode = 7
    
    // Wrong access token.
    case accessError = 8
    
    // Request is blocked or user is not allowed to send the request.
    case bannedRequest = 9
    
    // Too much requests.
    case limitError = 10
    
    // Method is deprecated.
    case obsoleteMethod = 11
    
    // Request is locked.
    case locked = 12
    
    // User is already registered.
    case alreadyRegistered = 13
    
    // User is not confirmed. This code is not applicable.
    case notConfirmed = 14
    
    // Attempt to create objects' duplicate.
    case duplicate = 15
    
    // Other error.
    case other = 100

}

open class ApiError: JSONModel {

    public let message: String
    public let code: Int
    public let type: ErrorType

    required public init(fromJson json: JSON) {
        message = json["message"].stringValue
        let code = json["code"].intValue
        self.code = code
        self.type = ErrorType(rawValue: code) ?? .other
    }

    public init(type: ErrorType, message: String) {
        self.code = type.rawValue
        self.type = type
        self.message = message
    }

    public func json() -> JSON {
        let json: [String: Any] = ["message": message,
            "code": code]
        return JSON(json)
    }

}

open class EmptyAnswer: JSONModel {

    public let success: Bool
    public let error: ApiError?

    init(_ success: Bool, error: ApiError? = nil) {
        self.success = success
        self.error = ApiError(type: ErrorType.other, message: "Unknown error")
    }

    required public init(fromJson json: JSON) {
        if let success = json["success"].bool {
            self.success = success
            if !success {
                self.error = ApiError(fromJson: json["error"])
            } else {
                self.error = ApiError(type: .other, message: "unknown error")
            }
        } else {
            self.success = false
            self.error = nil
        }
    }
    public func json() -> JSON {
        let json: [String: Any] = ["success": success]
        return JSON(json)
    }
}
open class Answer<T>: EmptyAnswer where T: JSONModel {
    public let data: T?
    init(data: T) {
        self.data = data
        super.init(true)
    }
    override init(_ success: Bool, error: ApiError? = nil) {
        self.data = nil
        super.init(success, error: error)
    }


    required public init(fromJson json: JSON) {
        if !json["data"].isEmpty {
            if let data: T = json["data"].asObject() {
                if var list = data as? IList {
                    if let tp = json["total_pages"].int {
                        list.total_count = tp
                    }
                    list.count = json["count"].int
                }
                self.data = data
            } else {
                self.data = nil
            }
        } else {
            self.data = nil
        }

        super.init(fromJson: json)
    }
    public override func json() -> JSON {
        var json = super.json() 
        json.setValue("data", data)
        return json
    }
}

