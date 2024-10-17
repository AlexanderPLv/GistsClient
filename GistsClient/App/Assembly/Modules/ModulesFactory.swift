//
//  ModulesFactory.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit

protocol OnboardingBuilderProtocol {
    func buildOnboardingScreen() -> OnboardingScreen
}

protocol MainBuilderProtocol {
    func buildListScreen() -> ListScreen
    func buildDetailsScreen(info: GistInfo) -> DetailsScreen
}

final class ModulesFactory {
   
    private let networkService = NetworkService()
    
    init() {
        
    }
    
    class func build() -> ModulesFactory {
        let factory = ModulesFactory()
        return factory
    }
}

extension ModulesFactory: OnboardingBuilderProtocol {
    
    func buildOnboardingScreen() -> OnboardingScreen {
        let controller = OnboardingScreen(networkService: networkService)
        return controller
    }
}

extension ModulesFactory: MainBuilderProtocol {
    
    func buildListScreen() -> ListScreen {
        let controller = ListScreen()
        return controller
    }
    
    func buildDetailsScreen(info: GistInfo) -> DetailsScreen {
        let controller = DetailsScreen(info: info)
        return controller
    }
}
