//
//  MainAssembly.swift
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

/// Пространство имен модуля Main
struct MainModule {
    
    /// Объект содержащий логику преобразования из `UIStoryboard` и `UIViewController`
    final class Convertor: ModuleStoryboardConvertor {
          
        static var storyboardName: UIStoryboard.Name {
            UIStoryboard.Name(rawValue: "Main")!
        }
        
        static var viewControllerName: UIViewController.Name {
            UIViewController.Name(class: MainViewController.self)!
        }
    }

    /// Объект содержащий логику создание модуля `Main` 
    /// с чистой иерархии (просто ViewController) 
    final class Builder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        func build(with initialState: InitialStateType) -> CArchModule {
            let module = Convertor.viewController(type: MainViewController.self)!
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            Convertor.viewController(type: MainViewController.self)!
        }
    }
}

/// Объект содержащий логику внедрение зависимости компонентов модула `Main`
final class MainAssembly: StoryboardModuleAssembly {
    
    required init() {
        print("MainModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIStoryboardContainer) {
        container.setInitCompleted(for: MainViewController.self) { (resolver, controller) in
            guard let presenter = resolver.unravel(MainPresentationLogic.self, 
                                                    arguments: controller as MainRenderingLogic,
                                                    controller as MainModuleStateRepresentable) else {
                fatalError("Could not to build Main module, module Presenter is nil")
            }
            controller.provider = resolver.unravel(MainProvisionLogic.self,
                                                   argument: presenter as MainPresentationLogic)
            controller.router = resolver.unravel(MainRoutingLogic.self,
                                                 argument: controller as TransitionController)
        }
    }
    
    func registerProvider(in container: DIStoryboardContainer) {
        container.record(MainProvisionLogic.self) { (_, presenter: MainPresentationLogic) in
            MainProvider(presenter: presenter)
        }
    }
    
    func registerPresenter(in container: DIStoryboardContainer) {
        container.record(MainPresentationLogic.self) { (_, view: MainRenderingLogic, state: MainModuleStateRepresentable) in
            MainPresenter(view: view, state: state)
        }
    }
    
    func registerRouter(in container: DIStoryboardContainer) {
        container.record(MainRoutingLogic.self) { (_, transitionController: TransitionController) in
            MainRouter(transitionController: transitionController)
        }
    }
}
