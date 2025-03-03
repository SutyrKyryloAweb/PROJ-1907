import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = HUGE
        layer.add(pulse, forKey: "pulse")
    }

    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIView {
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 19.5 / 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
}

extension UIColor {
    static let customPurple = UIColor(red: 61/255, green: 3/255, blue: 96/255, alpha: 1.0)
    static let customPink = UIColor(red: 205/255, green: 167/255, blue: 228/255, alpha: 1.0)
//    static let customRed = UIColor(red: 253/255, green: 95/255, blue: 106/255, alpha: 1.0)
//    static let customPink = UIColor(red: 228/255, green: 146/255, blue: 156/255, alpha: 1.0)
    
//    UIFont.systemFont(ofSize: 16, weight: .ultraLight) // 0.1
//    UIFont.systemFont(ofSize: 16, weight: .thin)       // 0.2
//    UIFont.systemFont(ofSize: 16, weight: .light)      // 0.3
//    UIFont.systemFont(ofSize: 16, weight: .regular)    // 0.4
//    UIFont.systemFont(ofSize: 16, weight: .medium)     // 0.5
//    UIFont.systemFont(ofSize: 16, weight: .semibold)   // 0.6
//    UIFont.systemFont(ofSize: 16, weight: .bold)       // 0.7
//    UIFont.systemFont(ofSize: 16, weight: .heavy)      // 0.8
//    UIFont.systemFont(ofSize: 16, weight: .black)      // 0.9
}

extension UIFont {
    enum Baloo2Weight: String {
        case regular = "Baloo2-Regular"
        case medium = "Baloo2-Medium"
        case semiBold = "Baloo2-SemiBold"
        case bold = "Baloo2-Bold"
        case extraBold = "Baloo2-ExtraBold"
    }

    static func baloo2(_ weight: Baloo2Weight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
