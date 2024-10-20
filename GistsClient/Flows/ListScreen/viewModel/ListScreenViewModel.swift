//
//  ListScreenViewModel.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 18.10.2024.
//

import UIKit
import Combine

protocol ListScreenViewModel {
    var navigationTitle: String { get }
    var totalCount: Int { get }
    var didUpdateData: PassthroughSubject<UpdateResult, Never> { get }
    func refresh()
    func fetchNextPage()
    func item(at index: Int) -> Gist
}

enum UpdateResult {
    case refresh
    case nextPage([IndexPath]?)
    case failure(Error)
}

final class ListScreenViewModelImpl: ListScreenViewModel {
    
    var didUpdateData = PassthroughSubject<UpdateResult, Never>()
    
    let navigationTitle = "Gists"
    
    private let networkService: NetworkService
    private var page = 1
    private var isFetchInProgress = false
    
    var items = [Gist]()
    var totalCount: Int {
        items.count
    }
    
    init(
        networkService: NetworkService,
        gistsCache: GistsCache
    ) {
        self.networkService = networkService
        self.items = gistsCache.get()
    }
    
    func item(at index: Int) -> Gist {
        items[index]
    }
    
    func fetchNextPage() {
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        networkService.getGistsList(page: page + 1) { [weak self] result in
            switch result {
            case .success(let list):
                self?.page += 1
                self?.items.append(contentsOf: list)
                let indexPathsToReload = self?.calculateIndexPathsToReload(from: list.count)
                self?.didUpdateData.send(.nextPage(indexPathsToReload))
            case .failure(let error):
                self?.didUpdateData.send(.failure(error))
            }
            self?.isFetchInProgress = false
        }
    }
    
    func refresh() {
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        page = 1
        networkService.getGistsList(page: page) { [weak self] result in
            switch result {
            case .success(let list):
                self?.items = list
                self?.didUpdateData.send(.refresh)
            case .failure(let error):
                self?.items = []
                self?.didUpdateData.send(.failure(error))
            }
            self?.isFetchInProgress = false
        }
    }
    
    private func calculateIndexPathsToReload(from newItemsCount: Int) -> [IndexPath] {
        let startIndex = items.count - newItemsCount
        let endIndex = startIndex + newItemsCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
