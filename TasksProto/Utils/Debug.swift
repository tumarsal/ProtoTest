import Foundation

func synced(_ lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

func fatalErrorIfDebug() {
    #if DEBUG
        // fatalError()
    #endif
}

func fatalErrorIfDebug(_ m: String) {
    #if DEBUG
        fatalError(m)
    #endif
}

func synced(_ lock: AnyObject, closure: () throws -> ()) throws {
    objc_sync_enter(lock)
    do {
        try closure()
        objc_sync_exit(lock)
    } catch(let e) {
        objc_sync_exit(lock)
        throw e
    }

}

func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
