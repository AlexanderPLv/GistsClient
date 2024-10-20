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
    func buildListScreen() -> GistsListScreen
    func buildDetailsScreen(gist: Gist) -> DetailsScreen
    func buildFileContentScreen(url: URL) -> FileContentScreen
}

final class ModulesFactory {
   
    private let networkService = NetworkServiceImpl.shared
    private let gistsCache = GistsCache.shared
    
    class func build() -> ModulesFactory {
        let factory = ModulesFactory()
        return factory
    }
}

extension ModulesFactory: OnboardingBuilderProtocol {
    
    func buildOnboardingScreen() -> OnboardingScreen {
        let viewModel = OnboardingScreenViewModelImpl(networkService: networkService, gistsCache: gistsCache)
        let controller = OnboardingScreen(viewModel: viewModel)
        return controller
    }
}

extension ModulesFactory: MainBuilderProtocol {
    
    func buildListScreen() -> GistsListScreen {
        let viewModel = ListScreenViewModelImpl(networkService: networkService, gistsCache: gistsCache)
        let controller = GistsListScreen(viewModel: viewModel)
        return controller
    }
    
    func buildDetailsScreen(gist: Gist) -> DetailsScreen {
        let viewModel = DetailsScreenViewModelImpl(gist: gist, networkService: networkService)
        let controller = DetailsScreen(viewModel: viewModel)
        return controller
    }
    
    func buildFileContentScreen(url: URL) -> FileContentScreen {
        let controller = FileContentScreen(url: url)
        return controller
    }
}
