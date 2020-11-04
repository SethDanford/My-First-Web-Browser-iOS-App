//
//  WebViewController.swift
//  Project4
//
//  Created by AnoraxAlmanac on 3/11/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    // The webview (thing that shows the internet, used for loading the websites).
    var webView: WKWebView!
    // The progress bar.
    var progressView: UIProgressView!
    // List of sites to chose from when "open" is pressed.
    var webSites = ["linkedin.com", "apple.com", "404kartik.me", "google.com.au"]
    // Site that was chosen in the table.
    var pickedSite: String?
    // Bocked websites.
    var notAllowedURLs = ["linkedin.com"]
    
    override func loadView() {
        // Creating the webview.
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Putting a button in the navigation bar (top right) for going forward in your series of navigations.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        // Putting a button in the navigation bar (top left) for going backward in your series of navigations.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        // Creating an "Open" button that will show a list of loadable websites.
        let open = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        // Creating a refresh button that will refresh the page when pressed.
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        //Creating a space between the "Open" button and the reload button.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Creating the progress bar.
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // Putting all of the things created above into a bottom toolbar.
        toolbarItems = [progressButton, open, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // Necessary for progress bar.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // The site that will load up initially.
        let url = URL(string: "https://" + pickedSite!)!
        // Load the website.
        webView.load(URLRequest(url: url))
        // Allows cool gesture for navigating backwards and forwards on the web.
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        // The title for the options.
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        // Adding websites to the list of website options.
        for website in webSites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        // Adding a cancel button.
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // Presenting the the options.
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    // The following function safely loads a webpage when chosen from the list of options.
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            return
        }
        if notAllowedURLs.contains(actionTitle) {
            // Setting ac to an alert.
            let ac = UIAlertController(title: "BLOCKED", message: "\(actionTitle) has been blocked.", preferredStyle: .alert)
            // Setting an action for that alert.
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            // Displaying the alert.
            present(ac, animated: true)
        } else {
            guard let url = URL(string: "https://" + actionTitle) else {
                return
        }
            webView.load(URLRequest(url: url))
        }
    }
    // This func runs one the webpage has been loaded. It will make the navigation bar title, the title of the webpage.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    // This func sets/updates the progress bar.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // To make the code easier to read.
        let url = navigationAction.request.url
        
        // Use this to unwrap the option url?.host. If url is bad then it will not continue.
        if let host = url?.host {
            for website in webSites {
                // See if website exits in the hostname.
                if host.contains(website) {
                    // This allows the website to load.
                    decisionHandler(.allow)
                    // Exit the method.
                    return
                }
            }
        }
        // If the if let above does not work then this stops the website from loading.
        decisionHandler(.cancel)
    }
}
