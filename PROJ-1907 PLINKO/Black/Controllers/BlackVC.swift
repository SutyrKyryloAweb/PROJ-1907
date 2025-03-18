@preconcurrency import WebKit
import UIKit
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib
import OneSignalFramework

class BlackVC: UIViewController, WKNavigationDelegate {
    
    private var loadingIndicator: UIActivityIndicatorView!
    private var webView: WKWebView!
    private var userContentController: WKUserContentController!
    private var _finalURL: URL?
    private var complition: (() -> Void)?
    private var isFirst = true
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .black
        loadURL(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupLoadingIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.webView.evaluateJavaScript("document.body.innerText") { (result, error) in
                if let text = result as? String, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.openWhiteVC()
                }
            }
        }
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.tintColor = .black
        webView.navigationDelegate = self
        webView.isHidden = true
        webView.allowsBackForwardNavigationGestures = true
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadURL(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        view.backgroundColor = webView.underPageBackgroundColor
        if let currentURL = webView.url {
            UserDefaults.standard.set(currentURL.absoluteString, forKey: "SavedBlackLink")
            UserDefaults.standard.synchronize()
        }
        if isFirst {
            changeRoot()
            isFirst = false
        }

    }
    func openWhiteVC() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            print("SceneDelegate not found")
            return
        }
        let whiteVC = StartVC()
        sceneDelegate.changeRootViewController(to: whiteVC)
    }
    func changeRoot() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            print("SceneDelegate not found")
            return
        }
        sceneDelegate.changeRootViewController(to: self)
    }
}
