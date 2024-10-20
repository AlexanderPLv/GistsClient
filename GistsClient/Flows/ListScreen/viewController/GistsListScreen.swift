//
//  GistsListScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Combine
import UIKit
import SnapKit

final class GistsListScreen: UIViewController {
    
    private var cancellable: AnyCancellable?
    var onDetailScreen: ((Gist) -> Void)?
    
    private var viewModel: ListScreenViewModel
    private let tableView: UITableView
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.attributedTitle = NSAttributedString(string: "Fetching Data...", attributes: nil)
        view.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return view
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let view = UIButton()
        view.setTitle("Try Again", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        view.addGestureRecognizer(tapGesture)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    init(
        viewModel: ListScreenViewModel
    ) {
        self.tableView = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetup()
        setupTableView()
        binding()
        if viewModel.totalCount == 0 {
            viewModel.refresh()
        }
    }
}

private extension GistsListScreen {
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.refresh()
    }
    
    func binding() {
        cancellable = viewModel.didUpdateData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                refreshControl.endRefreshing()
                switch result {
                case .refresh:
                    self.tryAgainButton.isHidden = true
                    tableView.isHidden = false
                    tableView.reloadData()
                case .nextPage(let indexPaths):
                    guard let indexPaths else {
                        return
                    }
                    tableView.performBatchUpdates {
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                    }
                case .failure(let error):
                    print(error)
                    if viewModel.totalCount == 0 {
                        self.tryAgainButton.isHidden = false
                        tableView.isHidden = true
                    }
                    self.presentAlert(message: error.localizedDescription)
                }
            }
    }
    
    func layoutSetup() {
        view.backgroundColor = .white
        self.title = viewModel.navigationTitle
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(tryAgainButton)
        tryAgainButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl
        tableView.contentInset = .init(top: 20, left: 0, bottom: 35, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(GistsListCell.self, forCellReuseIdentifier: GistsListCell.reuseIdentifier)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.totalCount - 10
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension GistsListScreen: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchNextPage()
        }
    }
}

extension GistsListScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        onDetailScreen?(item)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GistsListCell.reuseIdentifier, for: indexPath) as? GistsListCell else {
            fatalError("Unable to dequeue ReusableCell for '\(GistsListCell.reuseIdentifier)'")
        }
        let item = viewModel.item(at: indexPath.row)
        cell.viewModel = GistsListCellViewModel(
            avatarURL: item.owner.avatarURL,
            ownerName: item.owner.login,
            title: item.title ?? ""
        )
        cell.selectionStyle = .none
        return cell
    }
}
