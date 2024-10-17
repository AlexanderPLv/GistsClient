//
//  ListScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit
import SnapKit

final class ListScreen: UIViewController {
    
    var onDetailScreen: ((GistInfo) -> Void)?
    
    init() {
        
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

private extension ListScreen {
    
    func bind() {
        
    }
    
    func setupViews() {
        
    }
}
