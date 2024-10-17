//
//  CoordinatorFactory.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeMainCoordinator(
        with router: Routable
    ) -> Coordinator & MainCoordinatorOutput
    func makeOnboardingCoordinator(
        with router: Routable
    ) -> Coordinator & OnBoardingCoordinatorOutput
}

final class CoordinatorFactory {
    private lazy var modulesFactory = ModulesFactory.build()
}
 
extension CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeOnboardingCoordinator(with router: Routable) -> Coordinator
    & OnBoardingCoordinatorOutput {
        return OnBoardingCoordinator(router: router, factory: modulesFactory)
    }
    
    func makeMainCoordinator(with router: Routable) -> Coordinator
    & MainCoordinatorOutput {
        return MainCoordinator(router: router, factory: modulesFactory)
    }
}
