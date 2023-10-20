import CArch

protocol TestProtocolInc {}
protocol TestProtocolInc2 {}

@SyncAlias
protocol TestProtocol: TestProtocolInc, ErrorAsyncHandler {
    
    func syncFunction(_ object: Any)
    
    func asyncFunction(_ object: Any) async
    
    func asyncObtain(with id: String) async
    
    func asyncThrowsFunction(_ object: Any) async throws
    
    func asyncThrowsObtain(with id: String) async throws
    
    func asyncThrowsObtain(with id: String, and object: Any) async throws
}

final class Test: TestProtocol {
    
    func syncFunction(_ object: Any) {
        print(object)
    }
    
    func asyncFunction(_ object: Any) async {
        print(object)
    }
    
    func asyncObtain(with id: String) async {
        print(id)
    }
    
    func asyncThrowsFunction(_ object: Any) async throws {
        print(object)
    }
    
    func asyncThrowsObtain(with id: String) async throws {
        print(id)
    }
    
    func asyncThrowsObtain(with id: String, and object: Any) async throws {
        print(id, object)
    }
    
    func encountered(_ error: Swift.Error) {
        print(error)
    }
}

let test = Test()
test.asyncFunction(0)
test.asyncThrowsFunction("Some")
test.asyncThrowsObtain(with: "Id")

@UIContactor
@MainActor protocol TestUIProtocol: AnyObject {
    
    func function(_ object: Any)
    
    func function(with id: String)
    
    func function(with id: String, and object: Any)
    
    func function3(with id: String, and object: Any, and object1: Any, and object2: Any, and object3: Any)
    
    func function1(_ object: Any) async
    
    func function2(with id: String) async throws
    
    func function3(with id: String, and object: Any) -> Int
}

class TestUI: TestUIProtocol {
    
    nonisolated init() {}
    
    func function(_ object: Any) {
        print(object)
    }
    
    func function(with id: String) {
        print(id)
    }
    
    func function(with id: String, and object: Any) {
        print(id, object)
    }
    
    func function1(_ object: Any) async {
        print(object)
    }
    
    func function2(with id: String) async throws {
        print(id)
    }
    
    func function3(with id: String, and object: Any) -> Int {
        print(id, object)
        return 0
    }
    
    func function3(with id: String, and object: Any, and object1: Any, and object2: Any, and object3: Any) {
        print(id, object, object1, object2, object3)
    }
}

let testUI = TestUI()
//testUI.nonisolatedFunction("")
