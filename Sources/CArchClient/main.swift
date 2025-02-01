//
//  main.swift
//
//

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
testUI.nonisolatedFunction("")

private extension ImplementationsKeys {
    
    static let v1 = Self.init(rawValue: "v1")
    static let v2 = Self.init(rawValue: "v2")
    static let `default` = Self.init(rawValue: "default")
}

@Contract(implementations: [
    .init(type: SomeAgentV1Implementation.self, version: .v1),
    .init(type: SomeAgentV2Implementation.self, version: .v2),
    .init(type: SomeAgentImplementation.self, version: .default)
])
public protocol SomeAgent: BusinessLogicAgent, AutoResolve {}

@AutoResolvable
private actor SomeAgentImplementation: SomeAgent {
}

@AutoResolvable
private actor SomeAgentV1Implementation: SomeAgent {
}

@AutoResolvable
private actor SomeAgentV2Implementation: SomeAgent {
}

@Contract
protocol SomeService: BusinessLogicService, AutoResolve {}

@AutoResolvable(implementations: [.init(type: SomeAgent.self, version: .v1)])
private actor SomeServiceImplementation: SomeService {

    private let agent: SomeAgent
}

@Contract
protocol SomeController: BusinessLogicController, AutoResolve {}

@AutoResolvable(options: [.required, .convenience])
private class SomeControllerImplementation: SomeController {
    
    private let service: SomeService
}

@Contract(implementations: [.init(type: SomeSingletonImplementation.self, version: .default)])
protocol SomeSingleton: BusinessLogicSingleton, AutoResolve {}

@AutoResolvable
private actor SomeSingletonImplementation: SomeSingleton {
}

@Contract(options: .public)
public protocol SomePool: BusinessLogicServicePool, AutoResolve {}

@AutoResolvable
private actor SomePoolImplementation: SomePool {
}

@Contract
protocol SomeRootAgent: BusinessLogicAgent, AutoResolve {}

@AutoResolvable
private actor SomeRootAgentImplementation: SomeRootAgent {
}

@Contract
protocol SomeRoot2Agent: BusinessLogicAgent, AutoResolve {}

@AutoResolvable
private actor SomeRoot2AgentImplementation: SomeRoot2Agent {
}

@Contract
protocol SomeParentAgent: BusinessLogicAgent, SomeRootAgent, SomeRoot2Agent, AutoResolve {}

@AutoResolvable
private actor SomeParentAgentImplementation: SomeParentAgent {
}

@Assemblable
@AutoResolvable
class SomeFacade: AutoResolve {}

@AutoResolvable
@Assemblable(options: .freestanding)
class SomeFacade2: AutoResolve {}
