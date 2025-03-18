import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationVC: UINavigationController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        SportsDB.shared.loadSports()
        if(UserDefaults.standard.object(forKey: "currentSection") == nil ) {
            UserDefaults.standard.set(0, forKey: "currentSection")
        }
        let window = UIWindow(windowScene: windowScene)
        navigationVC = UINavigationController(rootViewController: LoadingVC())
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
    
    func changeNavRoot(to viewController: UIViewController, animated: Bool = false) {
        guard let window = self.window else {
            print("No window found")
            return
        }
        DispatchQueue.main.async
        {
            if animated {
                UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: {
                    self.navigationVC.setViewControllers([viewController], animated: false)
                }, completion: nil)
            } else {
                self.navigationVC.setViewControllers([viewController], animated: false)
            }
        }
    }
}

