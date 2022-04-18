//
//  ViewController.swift
//  project4
//
//  Created by Qing Li on 17/04/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    /// ❓Question: What does WKWebView! mean? Why is initializer not needed if ! is added?
    var webView: WKWebView!
    var progressView: UIProgressView!
    var legalWebsites = ["bbc.com", "apple.com", "hackingwithswift.com"]
    var illegalWebsites = ["notallowed.com", "isajoke.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTab)
        )

        createWebView()
        setupLayout()
        setupToolBar()
        
        let url = URL(string: "https://www." + legalWebsites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

    }
    
    private func createWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        /// ❓Question: Is this way of observing certain key path outdated?
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func setupLayout() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupToolBar() {
        let back = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward.circle"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        let forward = UIBarButtonItem(
            image: UIImage(systemName: "chevron.forward.circle"),
            style: .plain,
            target: self,
            action: #selector(forwardButtonTapped)
        )
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, spacer, progressButton, spacer, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func forwardButtonTapped() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func openTab() {
        let alert = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in legalWebsites + illegalWebsites {
            alert.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // important for iPad
        
        present(alert,animated: true)
    }
    
    private func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        
        /// show alert for illegal websites
        if illegalWebsites.contains(actionTitle) {
            let ac = UIAlertController(title: "Illegal website", message: "This website will not be opened", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        /// redirect to legal websites
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    /// Informs the observing object when the value at the specified key path relative to the observed object has changed.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}

// MARK: WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in legalWebsites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}

