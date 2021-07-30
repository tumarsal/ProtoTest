import Foundation
import SwiftyJSON

public extension UserDefaults {
    public func isKeyPresentInUserDefaults(key: String) -> Bool {
        return self.object(forKey: key) != nil
    }
    public func objectValue<T>(forKey: String) -> T? where T: JSONCreatable {
        if let s = self.stringValue(forKey: forKey) {
            let json = JSON.init(parseJSON: s)
            return T(fromJson: json)
        } else {
            return nil
        }
    }
    public func objectValue<T>(_ object: T?, forKey: String) where T: JSONModel {
        if let o = object {
            let json = o.asLineJsonString()
            self.set(json, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }

    }
    public func intValue(_ intValue: Int?, forKey: String) {
        if let o = intValue {
            self.set(o, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }
    }
    public func dateValue(_ date: Date?, forKey: String) {
        if let o = date {
            let long = o.timeIntervalSince1970Long
            self.set(long, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }
    }
    public func boolValue(_ bool: Bool?, forKey: String) {
        if let s = bool {
            self.set(s, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }
    }
    public func stringValue(_ string: String?, forKey: String) {
        if let s = string {
            self.set(s, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }
    }
    public func doubleValue(_ double: Double?, forKey: String) {
        if let d = double {
            self.set(d, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }

    }
    public func floatValue(_ double: Float?, forKey: String) {
        if let d = double {
            self.set(d, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }

    }
    public func floatValue(forKey: String, _ def: Float) -> Float {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Float = self.value(forKey: forKey) as! Float
            return s
        } else {
            return def
        }
    }
    public func dateValue(forKey: String, _ def: Date) -> Date {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s = self.int64Value(forKey: forKey)!
            return Date(timeIntervalSince1970Long: s)
        } else {
            dateValue(def, forKey: forKey)
            return def
        }
    }
    public func dateValue(forKey: String) -> Date? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s = self.int64Value(forKey: forKey)!
            return Date(timeIntervalSince1970Long: s)
        } else {
            return nil
        }
    }
    public func int64Value(_ int64: Int64?, forKey: String) {
        if let i = int64 {
            self.set(i, forKey: forKey)
        } else {
            self.removeObject(forKey: forKey)
        }

    }

    public func doubleValue(forKey: String) -> Double? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Double = self.value(forKey: forKey) as! Double
            return s
        } else {
            return nil
        }
    }
    public func doubleValue(forKey: String, _ def: Double) -> Double {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Double = self.value(forKey: forKey) as! Double
            return s
        } else {
            return def
        }
    }

    public func stringValue(forKey: String) -> String? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: String = self.value(forKey: forKey) as! String
            return s
        } else {
            return nil
        }
    }
    public func intValue(forKey: String) -> Int? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Int = self.value(forKey: forKey) as! Int
            return s
        } else {
            return nil
        }
    }
    public func boolValue(forKey: String) -> Bool? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Bool = self.value(forKey: forKey) as! Bool
            return s
        } else {
            return nil
        }
    }
    func int64Value(forKey: String) -> Int64? {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Int64 = self.value(forKey: forKey) as! Int64
            return s
        } else {
            return nil
        }
    }
    public func boolValue(forKey: String, _ def: Bool) -> Bool {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Bool = self.value(forKey: forKey) as! Bool
            return s
        } else {
            return def
        }
    }

    public func stringValue(forKey: String, _ def: String) -> String {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: String = self.value(forKey: forKey) as! String
            return s
        } else {
            return def
        }
    }
    public func intValue(forKey: String, _ def: Int) -> Int {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Int = self.value(forKey: forKey) as! Int
            return s
        } else {
            return def
        }
    }
    
    public func int64Value(forKey: String, def: Int64) -> Int64 {
        if self.isKeyPresentInUserDefaults(key: forKey) {
            let s: Int64 = self.value(forKey: forKey) as! Int64
            return s
        } else {
            return def
        }
    }
}
