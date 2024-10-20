//
//  GistDetailsSectionHeader.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import UIKit
import SnapKit

class GistDetailsSectionHeader: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .darkText
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GistDetailsSectionHeader {
    
    func setupView() {
        backgroundColor = .clear
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview()
        }
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
}
