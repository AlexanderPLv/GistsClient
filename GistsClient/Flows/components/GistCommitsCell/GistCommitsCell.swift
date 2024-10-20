//
//  GistCommitsCell.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 21.10.2024.
//

import UIKit

struct GistCommitsCellModel {
    let title: String
    let commitedAt: String
    let isLastItem: Bool
}

final class GistCommitsCell: UICollectionViewCell {
    
    private var titleMaxWidthConstraint: NSLayoutConstraint?
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            let width = maxWidth - 28
            titleMaxWidthConstraint?.constant = width
            titleMaxWidthConstraint?.isActive = true
        }
    }
    
    private let iconImageView: UIImageView = {
        let view = UIImageView(image: .commitsIcon)
        view.contentMode = .scaleAspectFill
        view.tintColor = .baseBackground
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemGray
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    var viewModel: GistCommitsCellModel? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.title
            dateLabel.text = "Commited at: \(viewModel.commitedAt)"
            if viewModel.isLastItem {
                separator.isHidden = true
                layer.cornerRadius = 10
                layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        separator.isHidden = false
        layer.cornerRadius = 0
    }
}

private extension GistCommitsCell {
    func setupViews() {
        backgroundColor = .white
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.leading.equalToSuperview().inset(13)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(10)
        }
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview()
        }
        titleMaxWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 0)
        titleMaxWidthConstraint?.isActive = false
    }
}
