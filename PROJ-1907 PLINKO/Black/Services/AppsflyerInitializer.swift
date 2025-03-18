import AppsFlyerLib

class AppsflyerInitializer: NSObject, AppsFlyerLibDelegate {
    
    var completion: ((String) -> Void)?
    private var _blackConfigs = BlackConfigs()
    
    init(blackConfigs: BlackConfigs) {
        super.init()
        
        _blackConfigs = blackConfigs
        
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = _blackConfigs.isDebug
        AppsFlyerLib.shared().appsFlyerDevKey = _blackConfigs.devKey
        AppsFlyerLib.shared().appleAppID = _blackConfigs.appId
        AppsFlyerLib.shared().start()
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        AppsFlyerLib.shared().logEvent("ConversionDataSuccess", withValues: conversionInfo)
        
        if let conversionData = conversionInfo as? [String: Any] {
            if let af_status = conversionData["af_status"] as? String {
                AppsFlyerLib.shared().logEvent("didReceiveConversionData", withValues: conversionData)
                
                completion?(af_status)
                
            }
        }
    }
    
    func onConversionDataFail(_ error: any Error) {
        NSLog("onConversionDataFail: \(error)")
        // _openerBlack?.GetAppsflyerConversionData(appsflyerConversionData: "ConversionDataFailed: \(error)");
        completion?("ConversionDataFailed: \(error)")
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        NSLog("onAppOpenAttribution \(attributionData)")
        // _openerBlack?.GetAppsflyerConversionData(appsflyerConversionData: "AppOpenAttribution: \(attributionData)");
        completion?("AppOpenAttribution: \(attributionData)")
    }
    
    func onAppOpenAttributionFailure(_ error: any Error) {
        NSLog("onAppOpenAttributionFailure \(error)")
        // _openerBlack?.GetAppsflyerConversionData(appsflyerConversionData: "AppOpenAttributionFailure: \(error)");
        completion?("AppOpenAttributionFailure: \(error)")
    }
}

