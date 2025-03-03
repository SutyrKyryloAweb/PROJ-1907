import UIKit

class ChooseVC: UIViewController {
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "infoButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let testButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "lockedButton"), for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var category: QuizCategory!
    var isLast: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        addBackground()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(infoButton)
        view.addSubview(testButton)
        
        let iconPlaceholder = UIImageView(image: UIImage(named: "levelImage"))
        iconPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(named: "\(category.category)"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        if(category.isCompleted ?? false) {
            testButton.setBackgroundImage(UIImage(named: "unlockedButton"), for: .normal)
            testButton.isEnabled = true
        }
        
        infoButton.addSubview(iconPlaceholder)
        iconPlaceholder.addSubview(icon)
        
        NSLayoutConstraint.activate([
            
            infoButton.widthAnchor.constraint(equalToConstant: 362),
            infoButton.heightAnchor.constraint(equalToConstant: 333),
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            
            testButton.widthAnchor.constraint(equalToConstant: 362),
            testButton.heightAnchor.constraint(equalToConstant: 333),
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 12),
            
            iconPlaceholder.widthAnchor.constraint(equalToConstant: 88),
            iconPlaceholder.heightAnchor.constraint(equalToConstant: 88),
            iconPlaceholder.centerXAnchor.constraint(equalTo: infoButton.centerXAnchor),
            iconPlaceholder.topAnchor.constraint(equalTo: infoButton.centerYAnchor, constant: -10),
            
            icon.leadingAnchor.constraint(equalTo: iconPlaceholder.leadingAnchor, constant: 15),
            icon.trailingAnchor.constraint(equalTo: iconPlaceholder.trailingAnchor, constant: -15),
            icon.topAnchor.constraint(equalTo: iconPlaceholder.topAnchor, constant: 15),
            icon.bottomAnchor.constraint(equalTo: iconPlaceholder.bottomAnchor, constant: -15),
            ])
        infoButton.addTarget(self, action: #selector(goToInfo), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(goToTest), for: .touchUpInside)
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    @objc func goToInfo() {
        let infoVC = InfoVC()
        infoVC.category = category
        infoVC.complitionHandler = {
            UIView.animate(withDuration: 0.3) {
                self.testButton.isEnabled = true
                self.testButton.setBackgroundImage(UIImage(named: "unlockedButton"), for: .normal)
            }
        }
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @objc func goToTest() {
        let testVC = TestVC()
        testVC.category = category
        testVC.isLast = self.isLast
        self.navigationController?.pushViewController(testVC, animated: true)

    }
}


class CustomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.alpha = 1
        }
    }
}
