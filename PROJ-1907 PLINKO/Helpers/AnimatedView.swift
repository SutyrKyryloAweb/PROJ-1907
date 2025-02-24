import UIKit

class AnimatedBorderView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
        
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 2.5, dy: 2.5), cornerRadius: 20).cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
        
        animateBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 2.5, dy: 2.5), cornerRadius: 20).cgPath
    }
    
    private func animateBorder() {
        let duration: CFTimeInterval = 6  // ⬅ Увеличиваем длительность (было 3 сек, теперь 6)
        
        let timingFunction = CAMediaTimingFunction(name: .linear)
        
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0)
        ].map { NSValue(cgPoint: $0) }
        startPointAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        startPointAnimation.duration = duration
        startPointAnimation.repeatCount = .infinity
        startPointAnimation.timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
        
        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0)
        ].map { NSValue(cgPoint: $0) }
        endPointAnimation.keyTimes = startPointAnimation.keyTimes
        endPointAnimation.duration = duration
        endPointAnimation.repeatCount = .infinity
        endPointAnimation.timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
        
        gradientLayer.add(startPointAnimation, forKey: "startPointAnimation")
        gradientLayer.add(endPointAnimation, forKey: "endPointAnimation")
    }
}
