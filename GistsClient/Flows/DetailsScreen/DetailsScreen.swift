//
//  DetailsScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit
import SnapKit

final class DetailsScreen: UIViewController {
    
    var close: CompletionBlock?
    
    private let info: GistInfo
    
    init(
        info: GistInfo
    ) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
}

private extension DetailsScreen {
    
    func bind() {
        
    }
    
    func setupViews() {
        
    }
}
