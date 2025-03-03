import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        SportsDB.shared.loadSports()
        if(UserDefaults.standard.object(forKey: "currentSection") == nil ) {
            UserDefaults.standard.set(0, forKey: "currentSection")
        }
        let window = UIWindow(windowScene: windowScene)
        let navigationVC = UINavigationController(rootViewController: StartVC())
        window.rootViewController = navigationVC
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func changeRootViewController(to viewController: UIViewController, animated: Bool = false) {
        guard let window = self.window else {
            print("No window found")
            return
        }
        DispatchQueue.main.async
        {
            if animated {
                UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: {
                    window.rootViewController = viewController
                }, completion: nil)
            } else {
                window.rootViewController = viewController
            }
        }
    }
}

