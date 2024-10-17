//
//  OnboardingScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit
import SnapKit

final class OnboardingScreen: UIViewController {
    
    var close: CompletionBlock?
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .logo)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let networkService: NetworkService
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension OnboardingScreen {
    
    func setupViews() {
        view.backgroundColor = .baseBackground
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
    }
}
