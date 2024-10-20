//
//  GistDetailsCell.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import UIKit

struct GistDetailsCellViewModel {
    let avatarURL: String
    let ownerName: String
    let title: String
}

final class GistDetailsCell: UICollectionViewCell {
    
    private let imageLoader: ImageLoader = NetworkServiceImpl.shared
    
    private var ownerNameMaxWidthConstraint: NSLayoutConstraint?
    private var titleMaxWidthConstraint: NSLayoutConstraint?
     
     var maxWidth: CGFloat? = nil {
         didSet {
             guard let maxWidth = maxWidth else {
                 return
             }
             let width = maxWidth - 32
             ownerNameMaxWidthConstraint?.constant = width
             titleMaxWidthConstraint?.constant = width
             ownerNameMaxWidthConstraint?.isActive = true
             titleMaxWidthConstraint?.isActive = true
         }
     }
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView(image: .imgPlaceholder)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 130
        view.clipsToBounds = true
        return view
    }()
    
    private let ownerNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.textColor = .darkGray
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .left
        return view
    }()
    
    var viewModel: GistDetailsCellViewModel? {
        didSet {
            guard let viewModel else { return }
            ownerNameLabel.text = viewModel.ownerName
            titleLabel.text = viewModel.title
            Task {
                let (image, urlString) = await imageLoader.fetchImage(with: viewModel.avatarURL)
                if urlString == viewModel.avatarURL {
                    avatarImageView.image = image
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = .imgPlaceholder
    }
}

private extension GistDetailsCell {
    func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(260)
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(ownerNameLabel)
        ownerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalTo(avatarImageView.snp.centerX)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerNameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(avatarImageView.snp.centerX)
            make.bottom.equalToSuperview().inset(16)
        }
        ownerNameMaxWidthConstraint = ownerNameLabel.widthAnchor.constraint(equalToConstant: 0)
        ownerNameMaxWidthConstraint?.isActive = false
        titleMaxWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 0)
        titleMaxWidthConstraint?.isActive = false
    }
}
