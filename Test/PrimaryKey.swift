import CoreData

protocol PrimaryKey {
    
    var id: Int64 { get }
    
}

func uniqueInt() -> Int64 {
    return indexCounter.nextIndex()
}

let indexCounter = {
    return ThreadSafeCounter()
}()

class ThreadSafeCounter {
    private var queue = DispatchQueue(label: "com.countermind.counter")
    private (set) var value: Int64 = 0
    
    func nextIndex() -> Int64 {
        queue.sync {
            value += 1
        }
        return value
    }
}
