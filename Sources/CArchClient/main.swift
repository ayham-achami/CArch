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

struct Test: TestProtocol {
    
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
