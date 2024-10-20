//
//  GistDetailsContentCell.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 21.10.2024.
//

import UIKit

struct GistDetailsContentCellModel {
    let title: String
    let iconName: String
    let isLastItem: Bool
}

final class GistDetailsContentCell: UICollectionViewCell {
    
    private var titleMaxWidthConstraint: NSLayoutConstraint?
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            let width = maxWidth - 78
            titleMaxWidthConstraint?.constant = width
            titleMaxWidthConstraint?.isActive = true
        }
    }
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.tintColor = .baseBackground
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.forward"))
        view.contentMode = .scaleAspectFill
        view.tintColor = .baseBackground
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .darkText
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    var viewModel: GistDetailsContentCellModel? {
        didSet {
            guard let viewModel else { return }
            iconImageView.image = UIImage(systemName: viewModel.iconName)
            titleLabel.text = viewModel.title
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

private extension GistDetailsContentCell {
    func setupViews() {
        backgroundColor = .white
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(10)
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
