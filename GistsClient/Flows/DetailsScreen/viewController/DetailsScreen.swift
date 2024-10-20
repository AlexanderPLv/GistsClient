//
//  DetailsScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit
import SnapKit
import Combine

final class DetailsScreen: UIViewController {
    
    var onContentScreen: ((URL) -> Void)?
    var cancellable: AnyCancellable?
    
    private let collectionView: UICollectionView
    private let viewModel: DetailsScreenViewModel
    private let layout: UICollectionViewFlowLayout
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.attributedTitle = NSAttributedString(string: "Fetching Data...", attributes: nil)
        view.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return view
    }()
    
    private var referenceWidth: CGFloat {
        collectionView.frame.width
        - collectionView.contentInset.left
        - collectionView.contentInset.right
    }
    
    init(
        viewModel: DetailsScreenViewModel
    ) {
        self.viewModel = viewModel
        self.layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView = .init(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetup()
        setupCollectionView()
        binding()
        viewModel.fetchCommits()
    }
}

private extension DetailsScreen {
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.fetchCommits()
    }
    
    func binding() {
        cancellable = viewModel.didUpdateData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.collectionView.reloadSections(IndexSet(integer: 2))
            }
    }
    
    func layoutSetup() {
        collectionView.backgroundColor = .baseBackground
        view.backgroundColor = .baseBackground
        self.title = viewModel.navigationTitle
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 20, left: 16, bottom: 35, right: 16)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.register(GistDetailsCell.self, forCellWithReuseIdentifier: GistDetailsCell.reuseIdentifier)
        collectionView.register(GistDetailsContentCell.self, forCellWithReuseIdentifier: GistDetailsContentCell.reuseIdentifier)
        collectionView.register(GistCommitsCell.self, forCellWithReuseIdentifier: GistCommitsCell.reuseIdentifier)
        collectionView.register(
            GistDetailsSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GistDetailsSectionHeader.reuseIdentifier
        )
    }
}

extension DetailsScreen: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            1
        case 1:
            viewModel.filesCount > 5 ? 5 : viewModel.filesCount
        case 2:
            viewModel.commitsCount
        default :
            0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistDetailsCell.reuseIdentifier, for: indexPath) as? GistDetailsCell else {
                fatalError("Unable to dequeue ReusableCell for '\(GistDetailsCell.reuseIdentifier)'")
            }
            cell.viewModel = .init(
                avatarURL: viewModel.gist.owner.avatarURL,
                ownerName: viewModel.gist.owner.login,
                title: viewModel.gist.title ?? ""
            )
            cell.maxWidth = referenceWidth
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistDetailsContentCell.reuseIdentifier, for: indexPath) as? GistDetailsContentCell else {
                fatalError("Unable to dequeue ReusableCell for '\(GistDetailsContentCell.reuseIdentifier)'")
            }
            let item = viewModel.file(at: indexPath.row)
            cell.viewModel = .init(
                title: item.filename,
                iconName: "folder.fill",
                isLastItem: indexPath.row == viewModel.filesCount - 1
            )
            cell.maxWidth = referenceWidth
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistCommitsCell.reuseIdentifier, for: indexPath) as? GistCommitsCell else {
                fatalError("Unable to dequeue ReusableCell for '\(GistCommitsCell.reuseIdentifier)'")
            }
            let item = viewModel.commit(at: indexPath.row)
            cell.viewModel = .init(
                title: item.owner.login,
                commitedAt: item.committedAt,
                isLastItem: indexPath.row == viewModel.commitsCount - 1
            )
            cell.maxWidth = referenceWidth
            return cell
        default :
            fatalError("Invalid section index: \(section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 1:
            viewModel.filesCount == 0 ? .zero : CGSize(width: referenceWidth, height: 70)
        case 2:
            viewModel.commitsCount == 0 ? .zero : CGSize(width: referenceWidth, height: 70)
        default:
                .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GistDetailsSectionHeader.reuseIdentifier,
                for: indexPath
            ) as? GistDetailsSectionHeader else { fatalError("dequeueReusableSupplementaryHeaderError.") }
            header.title = indexPath.section == 1 ? "Files" : "Commits"
            return header
        default:
            fatalError("Unexpected element kind")
        }
    }
}

extension DetailsScreen: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let section = indexPath.section
        switch section {
        case 0:
            let referenceHeight: CGFloat = 350
            return .init(width: referenceWidth, height: referenceHeight)
        case 1, 2:
            return .init(width: referenceWidth, height: 60)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let section = indexPath.section
        switch section {
        case 1:
            let file = viewModel.file(at: indexPath.item)
            guard let url = URL(string: file.rawURL) else {
                return
            }
            onContentScreen?(url)
        default :
            return
        }
    }
}
