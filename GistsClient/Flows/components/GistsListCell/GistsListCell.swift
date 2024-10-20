//
//  GistsListCell.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 18.10.2024.
//

import UIKit

struct GistsListCellViewModel {
    let avatarURL: String
    let ownerName: String
    let title: String
}

final class GistsListCell: UITableViewCell {
    
    private let imageLoader: ImageLoader = NetworkServiceImpl.shared
    
    private let avatar: UIImageView = {
        let view = UIImageView(image: .imgPlaceholder)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.color = .darkText
        return view
    }()
    
    private let ownerNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .darkText
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.textColor = .darkGray
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    var viewModel: GistsListCellViewModel? {
        didSet {
            guard let viewModel else {
                return
            }
            activityIndicator.startAnimating()
            ownerNameLabel.text = viewModel.ownerName
            titleLabel.text = viewModel.title
            Task {
                let (image, urlString) = await imageLoader.fetchImage(with: viewModel.avatarURL)
                activityIndicator.stopAnimating()
                if urlString == viewModel.avatarURL {
                    avatar.image = image
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = UIImage(resource: .imgPlaceholder)
    }
}

private extension GistsListCell {
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.leading.equalToSuperview().inset(16)
        }
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(avatar.snp.center)
        }
        addSubview(ownerNameLabel)
        ownerNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatar.snp.centerY)
            make.leading.equalTo(avatar.snp.trailing).offset(10)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}
