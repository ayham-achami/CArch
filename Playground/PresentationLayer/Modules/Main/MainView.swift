//
//  MainView.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CArch
import UIKit

/// Протокол реализующий логику получения данных из слоя бизнес логики
protocol MainProvisionLogic: RootProvisionLogic {}

/// Все взаимодействия пользователя с модулем
typealias MainUserInteraction = MainRendererUserInteraction // & <#SecondUserInteractionIfNeeded#>

/// Объект содержаний логику отображения данных
final class MainViewController: UIViewController {

    // MARK: - Module reference
    // private let moduleReference = assembly(MainAssembly.self)

    // MARK: - Injected properties
    var provider: MainProvisionLogic!
    var router: MainRoutingLogic!

    // MARK: - Outlet Renderers
    @IBOutlet private var renderer: MainRenderer!

    /// состояние модуля `Main`
    private var state = MainModuleState()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            try router.prepare(for: segue, sender: sender)
        } catch {
            assertionFailure("Error: [\(error)] Could not to prepare for segue \(segue)")
        }
    }
}

// MARK: - Main + Initializer
extension MainViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MainModuleState.InitialStateType.self)
    }
}

// MARK: - Main + StateRepresentable
extension MainViewController: MainModuleStateRepresentable {
    
    var readOnly: MainModuleReadOnlyState {
    	state
    }
}

// MARK: - Main + RenderingLogic
extension MainViewController: MainRenderingLogic {}

// MARK: - Main + UserInteraction
extension MainViewController: MainUserInteraction {}
