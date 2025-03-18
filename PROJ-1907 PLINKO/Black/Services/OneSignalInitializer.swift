import OneSignalFramework

class OneSignalInitializer {
    
    private var _blackConfigs: BlackConfigs?
    
    init(blackConfigs: BlackConfigs)
    {
        _blackConfigs = blackConfigs;
    }
    
    public func Initialize()
    {
        OneSignal.initialize(_blackConfigs?.oneSignalKey ?? "");
    }
    
    public func SetUserID(firebaseID: String)
    {
        OneSignal.login(firebaseID);
    }
}

