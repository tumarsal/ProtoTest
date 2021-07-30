import Foundation
class Math {
    static let PI = 3.1415926535897931
    static func Pow(_ d: Double, _ e: Double) -> Double {
        return pow(d, e)
    }
    static func Pow(_ d: Double, _ e: Int) -> Double {
        return pow(d, Double(e))
    }
    static func Pow(_ d: Int, _ e: Int) -> Int {
        return Int(pow(Double(d), Double(e)))
    }
    static func Pow64(_ d: Int64, _ e: Int) -> Int64 {
        switch e {
        case 0:
            return 1
        case 1:
            return d
        case 2:
            return d * d
        default:
            return d * Math.Pow64(d, e-1)
        }
    }

    static func Sin(_ d: Double) -> Double {
        return sin(d)
    }
    static func Cos(_ d: Double) -> Double {
        return cos(d)
    }
    static func Min(_ v1: Double, _ v2: Double) -> Double {
        return min(v1, v2)
    }
    static func Min(_ v1: Int, _ v2: Int) -> Int {
        return min(v1, v2)
    }
    static func Min(_ v1: Int?, _ v2: Int) -> Int {
        if let v = v1 {
            return min(v, v2)
        }
        return v2
    }
    static func Min(_ v1: Double?, _ v2: Double) -> Double {
        if let v = v1 {
            return min(v, v2)
        }
        return v2
    }
    static func Max<T>(_ v1: T, _ v2: T) -> T where T: RawRepresentable, T.RawValue == Int {
        if v1.rawValue > v2.rawValue {
            return v1
        }
        return v2
    }
    static func Min(_ v1: Int?, _ v2: Int?, _ v3: Int) -> Int {
        return Min(Min(v1, v2), v3)
    }
    static func Min(_ v1: Double?, _ v2: Double?, _ v3: Double) -> Double {
        return Min(Min(v1, v2), v3)
    }
    static func Min(_ v1: Double?, _ v2: Double?) -> Double? {
        if let v = v1, let vv = v2 {
            return min(v, vv)
        }
        if let v = v1 {
            return v
        }
        if let v = v2 {
            return v
        }
        return nil
    }
    static func Min(_ v1: Int?, _ v2: Int?) -> Int? {
        if let v = v1, let vv = v2 {
            return min(v, vv)
        }
        if let v = v1 {
            return v
        }
        if let v = v2 {
            return v
        }
        return nil
    }
    static func Min(_ v1: Int64, _ v2: Int64) -> Int64 {
        return min(v1, v2)
    }
    static func Max(_ v1: Double, _ v2: Double) -> Double {
        return max(v1, v2)
    }
    static func Round(_ v: Double) -> Double {
        return round(v)
    }
    static func Round(_ v: Double, _ k: Int) -> Double {
        let k = Pow(10.0, k)
        return Double(Int(v * k)) / k
    }
    static func Log(_ v: Double) -> Double {
        return log(v)
    }
    static func Atan(_ v: Double) -> Double {
        return atan(v)
    }
    static func Exp(_ v: Double) -> Double {
        return exp(v)
    }
    static func avg(_ numbers: Int...) -> Double {
        var sum = 0
        for number in numbers {
            sum += number
        }
        let ave: Double = Double(sum) / Double(numbers.count)
        return ave
    }
    static func avg(_ numbers: Double...) -> Double {
        var sum: Double = 0
        for number in numbers {
            sum += number
        }
        let ave: Double = Double(sum) / Double(numbers.count)
        return ave
    }
}
