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
    
    static let v1 = Self.init(rawKey: "v1")
    static let v2 = Self.init(rawKey: "v2")
    static let `default` = Self.init(rawKey: "default")
}

@Contract(implementations: [
    .v2: SomeAgentV2Implementation.self,
    .v1: SomeAgentV1Implementation.self,
    .default: SomeAgentImplementation.self
])
public protocol SomeAgent: BusinessLogicAgent, AutoResolve {}

private actor SomeAgentImplementation: SomeAgent {
    
    init(_ resolver: DIResolver) {}
}

private actor SomeAgentV1Implementation: SomeAgent {
    
    init(_ resolver: DIResolver) {}
}

private actor SomeAgentV2Implementation: SomeAgent {
    
    init(_ resolver: DIResolver) {}
}

@Contract
protocol SomeService: BusinessLogicService, AutoResolve {}

private actor SomeServiceImplementation: SomeService {

    private let agent: SomeAgent

    init(_ resolver: DIResolver) {
        self.init(agent: SomeAgentResolver(resolver).unravel(implementation: .v1))
    }

    init(agent: SomeAgent) {
        self.agent = agent
    }
}

@Contract(implementations: [.default: SomeSingletonImplementation.self])
protocol SomeSingleton: BusinessLogicSingleton, AutoResolve {}

private actor SomeSingletonImplementation: SomeSingleton {

    init(_ resolver: DIResolver) {}
}

@Contract(isPublicAssembly: true)
public protocol SomePool: BusinessLogicServicePool, AutoResolve {}

private actor SomePoolImplementation: SomePool {

    init(_ resolver: DIResolver) {
    }
}

@Contract
protocol SomeRootAgent: BusinessLogicAgent, AutoResolve {}

private actor SomeRootAgentImplementation: SomeRootAgent {
    
    init(_ resolver: DIResolver) {}
}

@Contract
protocol SomeRoot2Agent: BusinessLogicAgent, AutoResolve {}

private actor SomeRoot2AgentImplementation: SomeRoot2Agent {
    
    init(_ resolver: DIResolver) {}
}

@Contract
protocol SomeParentAgent: BusinessLogicAgent, SomeRootAgent, SomeRoot2Agent, AutoResolve {}

private actor SomeParentAgentImplementation: SomeParentAgent {
    
    init(_ resolver: DIResolver) {}
}
