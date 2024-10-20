//
//  OnboardingScreenViewModel.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 18.10.2024.
//

import Foundation

protocol OnboardingScreenViewModel {
    func prefetchData(completion: @escaping CompletionBlock)
}

final class OnboardingScreenViewModelImpl: OnboardingScreenViewModel {
    
    private let networkService: NetworkService
    private let gistsCache: GistsCache
    
    init(
        networkService: NetworkService,
        gistsCache: GistsCache
    ) {
        self.networkService = networkService
        self.gistsCache = gistsCache
    }
    
    func prefetchData(completion: @escaping CompletionBlock) {
        networkService.getGistsList(page: 1) { [weak self] result in
            switch result {
            case .success(let list):
                self?.gistsCache.cache(list)
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
}
