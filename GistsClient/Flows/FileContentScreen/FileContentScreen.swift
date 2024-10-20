//
//  FileContentScreen.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 21.10.2024.
//

import UIKit
import SnapKit
import WebKit

final class FileContentScreen: UIViewController {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .darkText
        view.numberOfLines = 1
        view.text = "File Content"
        view.textAlignment = .center
        return view
    }()
    
    private let errorLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .darkText
        view.numberOfLines = 1
        view.text = "Load failure"
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.color = .darkText
        return view
    }()
    
    private let webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    private let url: URL
    
    init(
        url: URL
    ) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
}

extension FileContentScreen: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
    }
}

private extension FileContentScreen {
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
