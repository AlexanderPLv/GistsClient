//
//  MainCoordinator.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

protocol MainCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}
 
final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    fileprivate let factory: MainBuilderProtocol
    fileprivate let router: Routable
    
    init(
        router: Routable,
        factory: MainBuilderProtocol
    ) {
        self.router = router
        self.factory = factory
    }
}
 
extension MainCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension MainCoordinator {
    func performFlow() {
        let view = factory.buildListScreen()
        view.onDetailScreen = { [weak self] info in
            self?.runDetailScreen(info: info)
        }
        router.setRootModule(view, hideBar: true)
    }
    
    func runDetailScreen(info: Gist) {
        let view = factory.buildDetailsScreen(info: info)
        view.close = pop
        router.push(view, animated: true)
    }
    
    func pop() {
        router.popModule()
    }
}
