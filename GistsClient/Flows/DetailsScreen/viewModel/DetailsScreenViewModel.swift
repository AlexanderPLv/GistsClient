//
//  DetailsScreenViewModel.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import Foundation
import Combine

protocol DetailsScreenViewModel {
    var gist: Gist { get }
    var commits: [Commit] { get }
    var filesCount: Int { get }
    var commitsCount: Int { get }
    var navigationTitle: String { get }
    var didUpdateData: PassthroughSubject<Void, Never> { get }
    func file(at index: Int) -> GistFile
    func commit(at index: Int) -> Commit
    func fetchCommits()
}

final class DetailsScreenViewModelImpl: DetailsScreenViewModel {
    
    var didUpdateData = PassthroughSubject<Void, Never>()
    
    let navigationTitle = "Gist Details"
    
    let gist: Gist
    var filesCount: Int {
        gist.files.count
    }
    var commitsCount: Int {
        commits.count
    }
    private(set) var commits: [Commit] = []
    private let networkService: NetworkService
    private var page = 1
    private var isFetchInProgress = false
    
    init(
        gist: Gist,
        networkService: NetworkService
    ) {
        self.gist = gist
        self.networkService = networkService
    }
    
    func file(at index: Int) -> GistFile {
        gist.files[index]
    }
    
    func commit(at index: Int) -> Commit {
        commits[index]
    }
    
    func fetchCommits() {
        networkService.getCommits(urlString: gist.commitsURL) { [weak self] result in
            switch result {
                case .success(let list):
                self?.commits.removeAll()
                self?.commits = list
                self?.didUpdateData.send()
            case .failure(let error):
                print(error)
            }
        }
    }
}
