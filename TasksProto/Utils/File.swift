import Foundation

class FileUtil {

    static func logError(_ error: String) {
        print("FILE_UTIL: \(error)")
        //        fatalErrorIfDebug()
    }

    static func renameFile(file: String, to: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: file, toPath: to)
            return true
        } catch {
            return false
        }
    }

    static func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["BT", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }

    static func bite(kb: Int) -> Int64 {
        return Int64(kb) * Math.Pow64(Int64(1024), 3)
    }

    static func bite(mb: Int) -> Int64 {
        return Int64(mb) * Math.Pow64(Int64(1024), 4)
    }

    static func bite(gb: Int) -> Int64 {
        return Int64(gb) * Math.Pow64(Int64(1024), 5)
    }

    static let relativeString = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.relativeString

    static func stringSizeOf(file: String) -> String {
        if let size = FileUtil.sizeOf(file: file) {
            return FileUtil.covertToFileString(with: size)
        }
        return "no"
    }

    static func createDate(file: String) -> Date? {
        let fileManager = FileManager.default
        let relativeString = FileUtil.relativeString
        let filePath = URL(string: "\(relativeString)\(file)")!
        do {
            if fileManager.fileExists(atPath: filePath.path) {
                let attr = try fileManager.attributesOfItem(atPath: filePath.path)
                let createDate = attr[FileAttributeKey.creationDate] as! Date
                return createDate
            } else {
                return nil
            }
        } catch (let e) {
            logError(e.localizedDescription)
            return nil
        }
    }

    static func lastModifyDate(file: String) -> Date? {
        let fileManager = FileManager.default
        let relativeString = FileUtil.relativeString
        let filePath = URL(string: "\(relativeString)\(file)")!
        do {
            if fileManager.fileExists(atPath: filePath.path) {
                let attr = try fileManager.attributesOfItem(atPath: filePath.path)
                let createDate = attr[FileAttributeKey.modificationDate] as! Date
                return createDate
            } else {
                return nil
            }
        } catch (let e) {
            logError(e.localizedDescription)
            return nil
        }
    }

    static func sizeOf(url: URL) -> UInt64? {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            if let fileSize = resources.fileSize {
                return UInt64(fileSize)
            } else {
                return nil
            }
        } catch (let e) {
            logError(e.localizedDescription)
            return nil
        }
    }

    static func sizeOf(file: String) -> UInt64? {
        let fileManager = FileManager.default
        let relativeString = FileUtil.relativeString
        let filePath = URL(string: "\(relativeString)\(file)")!
        do {
            if fileManager.fileExists(atPath: filePath.path) {
                let attr = try fileManager.attributesOfItem(atPath: filePath.path)
                let fileSize = attr[FileAttributeKey.size] as! UInt64
                return fileSize
            } else {
                return nil
            }


        } catch (let e) {
            logError(e.localizedDescription)
            return nil
        }
    }

    static func saveText(text: String, to: String) {
        let relativeString = FileUtil.relativeString
        let filePath = URL(string: "\(relativeString)\(to)")!
        do {
            let fileHandle = try FileHandle(forWritingTo: filePath)
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.data(using: String.Encoding.utf8)!)
        } catch {
            print("Write to File error \(error.localizedDescription)")
            do {
                try text.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            } catch (let e) {
                logError(e.localizedDescription)
            }
        }
    }

    static func removeFile(_ file: String) {
        do {
            let fileManager = FileManager.default
            let relativeString = FileUtil.relativeString
            let filePath = URL(string: "\(relativeString)\(file)")!
            if fileManager.fileExists(atPath: filePath.path) {
                try FileManager.default.removeItem(at: filePath)
            }
        } catch (let e) {
            logError(e.localizedDescription)
        }
    }

    static func loadTextFrom(url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: String.Encoding.utf8)
        } catch (let e) {
            logError(e.localizedDescription)
        }
        return nil
    }

    static func loadTextFrom(file: String) -> String? {
        do {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let relativeString = dir.relativeString
                let filePath = URL(string: "\(relativeString)\(file)")!
                return try String(contentsOf: filePath, encoding: String.Encoding.utf8)
            }
        } catch(let e) {
            logError(e.localizedDescription)
        }

        return nil
    }

    static func loadTextFrom(file: String,
        proccess: ((_ process: UInt64, _ total: UInt64) -> Void)?,
        error: (() -> Void)?,
        _ end: @escaping () -> ()) -> FileReader? {
        do {
            let relativeString = FileUtil.relativeString
            let filePath = URL(string: "\(relativeString)\(file)")!
            if FileManager.default.fileExists(atPath: filePath.path) {
                let fileHandle = try FileHandle(forReadingFrom: filePath)
                return FileReader(fileHandle, proccess: proccess, error: error, end)
            }
        } catch (let e) {
            logError(e.localizedDescription)
        }
        return nil;
    }
}

typealias CallBack = () -> ()

class MultiFileReader: IFileReader {

    func close() {

    }

    func offsetChange(_ offset: UInt64) {

    }

    let end: CallBack
    let files: [String]
    let proccess: ((_ process: Int, _ total: Int) -> Void)?
    let error: (() -> Void)?
    var cr: FileReader?

    init(_ files: [String],
        proccess: ((_ process: Int, _ total: Int) -> Void)?,
        error: (() -> Void)?,
        _ end: @escaping CallBack) {
        self.files = files
        self.error = error
        self.proccess = proccess
        self.end = end
    }

    func next(_ callBack: @escaping (_ s: String, _ errorOffset: UInt64) -> ()) {
        let relativeString = FileUtil.relativeString
        do {
            var handles: [FileHandle] = []
            for file in self.files {
                let filePath = URL(string: "\(relativeString)\(file)")!
                if FileManager.default.fileExists(atPath: filePath.path) {
                    let fileHandle = try FileHandle(forReadingFrom: filePath)
                    handles.append(fileHandle)
                }
            }

            var rs: [FileReader] = []
            var endCallBack = self.end
            var i = 0
            for handle in handles.reversed() {
                let fr = FileReader(handle, proccess: nil, error: nil, endCallBack)
                cr = fr
                let index = i
                endCallBack = { () in
                    if rs.count > index {
                        self.cr = rs[index]
                        rs[index].next(callBack)
                    }
                }
                rs.append(fr)
                i += 1;
            }
        } catch {

        }
    }
}

protocol IFileReader {

    func next(_ callBack: @escaping (_ s: String, _ errorOffset: UInt64) -> ())
    func close()
    func offsetChange(_ offset: UInt64)

}

class FileReader: IFileReader {

    let fileHandle: FileHandle
    let end: CallBack

    var proccess: ((_ process: UInt64, _ total: UInt64) -> Void)?
    var error: (() -> Void)?
    let fileLength: UInt64
    var currentOffset: UInt64
    let dataPartSizeU: Int = 5000
    let dataPartSizeU64: Int64 = 5000

    let smallPartSize: Int = 500
    let smallPartSize64: Int64 = 500

    let lineEndChar: Character = Character("\n")

    func logFunction(_ f: String, data: String) {
        print("CF_FL:\(f) \(data)")
    }

    func logFunction(_ f: String) {
        logFunction(f, data: "")
    }

    func offsetChange(_ offset: UInt64) {
        self.currentOffset = offset
        error?()
    }

    init(_ fileHandle: FileHandle,
        proccess: ((_ process: UInt64, _ total: UInt64) -> Void)?,
        error: (() -> Void)?,
        _ end: @escaping CallBack) {
        self.fileHandle = fileHandle
        self.error = error
        self.proccess = proccess
        fileHandle.seekToEndOfFile()
        fileLength = fileHandle.offsetInFile
        currentOffset = 0
        self.end = end
    }

    func next (_ callBack: @escaping (_ s: String, _ errorOffset: UInt64) -> ()) {
        logFunction(#function, data: "\(currentOffset) \(fileLength)")
        if currentOffset < fileLength {
            fileHandle.seek(toFileOffset: currentOffset)
            let readLenght = Math.Min(Int64(fileLength - currentOffset), self.dataPartSizeU64)
            let errorOffset = currentOffset
            currentOffset += UInt64(dataPartSizeU)
            if var fromFileText = fileHandle.readString(ofLength: Int(readLenght)) {
                var endOfBlock = false
                while !endOfBlock {
                    if currentOffset >= fileLength {
                        self.currentOffset = fileLength
                        endOfBlock = true
                    } else {
                        if var smallPart = fileHandle.readString(ofLength: self.smallPartSize) {
                            if let index = smallPart.firstIndex(of: self.lineEndChar) {
                                smallPart = smallPart.substring(to: index.encodedOffset)
                                currentOffset += UInt64(index.encodedOffset) + 1
                                fromFileText.append(smallPart)
                                endOfBlock = true;
                            } else {
                                fromFileText.append(smallPart)
                                currentOffset += UInt64(self.smallPartSize64)
                            }
                        } else {
                            endOfBlock = true
                        }
                    }
                }
                print(fromFileText)
                callBack(fromFileText, errorOffset)
                if let proccess = self.proccess {
                    proccess(errorOffset, fileLength)
                }
            } else {
                fileHandle.closeFile()
                end()
            }
        } else {
            logFunction(#function)
            fileHandle.closeFile()
            end()
        }
    }

    func close() {
        fileHandle.closeFile()
    }

}

extension FileHandle {

    func readString(ofLength: Int) -> String? {
        let data = self.readData(ofLength: ofLength)
        let content = String(data: data, encoding: String.Encoding.utf8)
        return content
    }

}
