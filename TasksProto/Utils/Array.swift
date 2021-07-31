//
//  Array.swift
//  Safe Buisness
//
//  Created by Alex Mankov on 09/12/2018.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
extension Sequence {
    public func uniqueBy(_ f:((Iterator.Element)->String)) -> [Iterator.Element] {
        var seen: [String: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: f($0)) == nil }
    }
}
extension Array {
    public func find(_ f:((_ item: Element)->Bool)) -> Element? {
        for item in self {
            if f(item) {
                return item
            }
        }
        return nil
    }
    public func findWithIndex(_ f:((_ item: Element)->Bool)) -> (Element,Int)? {
        var i = 0
        for item in self {
            if f(item) {
                return (item,i)
            }
            i+=1;
        }
        return nil
    }
    
    public func findValue(_ f:((_ item: Element)->Bool)) -> Element {
        for item in self {
            if f(item) {
                return item
            }
        }
        fatalError()
    }
    public func max(_ f:((_ item: Element)->Int)) -> Int? {
        var max:Int?
        for item in self {
            let value = f(item)
            if let maxValue = max {
                if value > maxValue {
                    max = value
                }
            } else {
                max = value
            }
            
        }
        return max
    }
    public func sum(_ f:((_ item: Element)->Int)) -> Int {
        var sum:Int = 0
        for item in self {
            let value = f(item)
            sum += value
            
        }
        return sum
    }
    public func min(_ f:((_ item: Element)->Int)) -> Int? {
        var min:Int?
        for item in self {
            let value = f(item)
            if let maxValue = min {
                if value < maxValue {
                    min = value
                }
            } else {
                min = value
            }
            
        }
        return min
    }
    public func max(_ f:((_ item: Element)->Double)) -> Double? {
        var max:Double?
        for item in self {
            let value = f(item)
            if let maxValue = max {
                if value > maxValue {
                    max = value
                }
            } else {
                max = value
            }
            
        }
        return max
    }
    public func maxBy(_ f:((_ item: Element)->Double)) -> Element? {
        var max:Double?
        var maxitem:Element?
        for item in self {
            let value = f(item)
            if let maxValue = max {
                if value > maxValue {
                    max = value
                    maxitem = item
                }
            } else {
                max = value
                maxitem = item
            }
            
        }
        return maxitem
    }
    public func minBy(_ f:((_ item: Element)->Double)) -> Element? {
        var max:Double?
        var maxitem:Element?
        for item in self {
            let value = f(item)
            if let maxValue = max {
                if value < maxValue {
                    max = value
                    maxitem = item
                }
            } else {
                max = value
                maxitem = item
            }
            
        }
        return maxitem
    }
    
    public func min(_ f:((_ item: Element)->Double)) -> Double? {
        var min:Double?
        for item in self {
            let value = f(item)
            if let maxValue = min {
                if value < maxValue {
                    min = value
                }
            } else {
                min = value
            }
            
        }
        return min
    }
    public func mapNotNull(_ f:((_ item: Element)->Int?)) -> [Int]{
        var innts:[Int] = []
        for item in self {
            if let res = f(item) {
                innts.append(res)
            }
        }
        return innts
    }
    public func cast<T>() -> [T] {
        
        return self.map({ (el) -> T in
            return el as! T
        })
    }
    public func chank(_ count:Int) -> [[Element]] {
        var result:[[Element]] = []
        var chank:[Element] = []
        var index = 0
        for item in self {
            if index < count {
                chank.append(item)
                index += 1
            } else {
                if chank.count > 0 {
                    result.append(chank)
                }
                index = 1
                chank = [item]
            }
        }
        if chank.count > 0 {
            result.append(chank)
        }
        return result
    }
    public func all(_ f:((_ item: Element)->Bool)) -> Bool {
        
        for item in self {
            if !f(item) {
                return false
            }
        }
        return true
    }
    public func all(_ f:((_ index:Int,_ item: Element)->Bool)) -> Bool {
        var i = 0
        for item in self {
            if !f(i,item) {
                return false
            }
            i += 1
        }
        return true
    }
    public func join(_ ch:String)->String{
        var s = ""
        for item in self {
            if s == "" {
                s = "\(item)"
            } else {
                s = "\(s)\(ch)\(item)"
            }
        }
        return s
    }
    public func any(_ f:((_ item: Element)->Bool)) -> Bool {
        
        for item in self {
            if f(item) {
                return true
            }
        }
        return false
    }
    public func any(_ f:((_ index:Int,_ item: Element)->Bool)) -> Bool {
        var i = 0
        for item in self {
            if f(i,item) {
                return true
            }
            i += 1
        }
        return false
    }
    public mutating func removeFirstOptional() -> Element? {
        let count = self.count
        if count > 0 {
            return self.removeFirst()
        }
        return nil
    }
    public mutating func removeAll(lock:NSObject) -> [Element]? {
        var res:[Element]? = nil
        synced(lock) {
            res = self.map({ (item) -> Element in
                item
            })
            self.removeAll()
        }
        return res
    }
    public mutating func append(_ el:Element, lock:NSObject) {
        synced(lock) {
            self.append(el)
        }
    }
    public mutating func removeFirstOptional(lock:NSObject) -> Element? {
        var res:Element? = nil
        synced(lock) {
            if self.count > 0 {
                res = self.removeFirst()
            }
        }
        return res
    }
    public mutating func removeFirst(_ f:((_ item: Element)->Bool)) -> Element? {
        var i = 0
        for item in self {
            if f(item) {
                self.remove(at: i)
                return item
            }
            i += 1
        }
        return nil
    }
    public mutating func removeFirstFromIndex(from:Int,_ f:((_ item: Element)->Bool)) -> Int {
        for i in (from ..< self.count){
            let item = self[from]
            if f(item) {
                self.remove(at: i)
                return i
            }
        }
        return 0
    }
    public mutating func removeFirstValue(_ f:((_ item: Element)->Bool)) {
        
        var i = 0
        for item in self {
            if f(item) {
                self.remove(at: i)
            }
            i += 1
        }
    }
    public mutating func removeAll(_ f:((_ item: Element)->Bool))  {
        for i in (0..<self.count).reversed() {
            if self.count > i {
                if f(self[i]) {
                    self.remove(at: i)
                }
            }
            
        }
    }
    
}
extension Array where Element : Equatable {
    public var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}


extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    public mutating func remove(value: Element)-> Bool {
        if let index = index(of: value) {
            remove(at: index)
            return true
        }
        return false
    }
    public mutating func removeValue(_ value: Element) {
        if let index = index(of: value) {
            remove(at: index)
        }
    }
}
