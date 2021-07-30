import Foundation

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    func isGuid() -> Bool {
        return self.matches("^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$")
    }

    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    static private let SNAKECASE_PATTERN: String = "(\\w{0,1})_"
    static private let CAMELCASE_PATTERN: String = "[A-Z][a-z,\\d]*"
    func camelCase() -> String {
        let buf: NSString = self.capitalized.replacingOccurrences(of: String.SNAKECASE_PATTERN,
            with: "$1",
            options: .regularExpression,
            range: nil) as NSString
        return buf.replacingCharacters(in: NSMakeRange(0, 1), with: buf.substring(to: 1).lowercased()) as String
    }
    func snake_case() throws -> String {
        guard let pattern: NSRegularExpression = try? NSRegularExpression(pattern: String.CAMELCASE_PATTERN,
            options: []) else {
            throw NSError(domain: "NSRegularExpression fatal error occured.", code: -1, userInfo: nil)
        }

        let input: NSString = (self as NSString).replacingCharacters(in: NSMakeRange(0, 1), with: (self as NSString).substring(to: 1).capitalized) as NSString
        var array = [String]()
        let matches = pattern.matches(in: input as String, options: [], range: NSRange(location: 0, length: input.length))
        for match in matches {
            for index in 0..<match.numberOfRanges {
                array.append(input.substring(with: match.range(at: index)).lowercased())
            }
        }
        return array.joined(separator: "_")
    }
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }

        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }

        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }

        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }

        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }

        return String(self[startIndex ..< endIndex])
    }

    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    func char(_ index: Int) -> String {
        return self.substring(from: index, to: index + 1)
    }

    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }

    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }

        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }

        return self.substring(from: from, to: end)
    }

    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }

        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }

        return self.substring(from: start, to: to)
    }
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func getAllLinks() -> [URL] {
        var urls: [URL] = []
        let types: NSTextCheckingResult.CheckingType = NSTextCheckingResult.CheckingType.link

        do {
            let text = self
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            if matches.count > 0 {
                if let url = matches[0].url {
                    urls.append(url)
                }
            }

        } catch {
            // none found or some other issue
            print ("error in findAndOpenURL detector")
        }
        return urls
    }
}
public class RandomString {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
