//
//  OnboardingCoordinator.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

protocol OnBoardingCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}
 
final class OnBoardingCoordinator: BaseCoordinator, OnBoardingCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    fileprivate let factory: OnboardingBuilderProtocol
    fileprivate let router: Routable
    
    init(
        router: Routable,
        factory: OnboardingBuilderProtocol
    ) {
        self.router = router
        self.factory = factory
    }
}
 
extension OnBoardingCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension OnBoardingCoordinator {
    func performFlow() {
        let view = factory.buildOnboardingScreen()
        view.close = finishFlow
        router.setRootModule(view, hideBar: true)
    }
}
