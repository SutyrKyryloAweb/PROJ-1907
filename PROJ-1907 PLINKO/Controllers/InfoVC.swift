import UIKit

class InfoVC: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's start"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "1/3"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "defaultButton"), for: .normal)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "transperantButton"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.customPink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isEnabled = false
        return button
    }()
    
    private let innerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fullTextImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var category: QuizCategory!
    var currentState = 0
    private var infoStrings: [String] = []
    
    var complitionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        setupUI()
        
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(secondaryLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        let iconPlaceholder = UIImageView(image: UIImage(named: "levelImage"))
        iconPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(named: "\(category.category)"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        
        placeholderImageView.addSubview(iconPlaceholder)
        iconPlaceholder.addSubview(icon)
        placeholderImageView.addSubview(innerTitleLabel)
        placeholderImageView.addSubview(infoText)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 40),
            
            placeholderImageView.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 10),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 362),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 510),
            
            iconPlaceholder.topAnchor.constraint(equalTo: placeholderImageView.topAnchor, constant: 10),
            iconPlaceholder.widthAnchor.constraint(equalToConstant: 88),
            iconPlaceholder.heightAnchor.constraint(equalToConstant: 88),
            iconPlaceholder.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            icon.topAnchor.constraint(equalTo: iconPlaceholder.topAnchor, constant: 15),
            icon.leadingAnchor.constraint(equalTo: iconPlaceholder.leadingAnchor, constant: 15),
            icon.trailingAnchor.constraint(equalTo: iconPlaceholder.trailingAnchor, constant: -15),
            icon.bottomAnchor.constraint(equalTo: iconPlaceholder.bottomAnchor, constant: -15),
            
            innerTitleLabel.topAnchor.constraint(equalTo: iconPlaceholder.bottomAnchor, constant: 10),
            innerTitleLabel.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 10),
            innerTitleLabel.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -10),
            innerTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            infoText.topAnchor.constraint(equalTo: innerTitleLabel.bottomAnchor, constant: 10),
            infoText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            infoText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            infoText.bottomAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 362),
            backButton.heightAnchor.constraint(equalToConstant: 64),
            
            nextButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 362),
            nextButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        nextButton.addTarget(self, action: #selector(handleTapNext), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleTapBack), for: .touchUpInside)
        innerTitleLabel.text = "Crazy \(category.category) facts"
        infoText.text = category.questions[0].questionInfo + "\n" + category.questions[1].questionInfo + "\n" + category.questions[2].questionInfo + "\n" + category.questions[3].questionInfo
        
        setupInfoText()
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    @objc func handleTapNext() {
        currentState += 1
        changeUI()
    }
    
    @objc func handleTapBack() {
        currentState -= 1
        changeUI()
    }
    
    func changeUI() {
        nextButton.isEnabled = false
        backButton.isEnabled = false
        switch(currentState) {
        case 0:
            UIView.animate(withDuration: 0.3) {
                self.infoText.alpha = 0
            } completion: { _ in
                self.secondaryLabel.text = "1/3"
                self.nextButton.isEnabled = true
                self.nextButton.setTitle("Next", for: .normal)
                self.backButton.alpha = 0
                self.backButton.isEnabled = false
                self.setupInfoText()
                UIView.animate(withDuration: 0.3) {
                    self.infoText.alpha = 1
                }
            }
        case 1:
            UIView.animate(withDuration: 0.3) {
                self.infoText.alpha = 0
            } completion: { _ in
                self.secondaryLabel.text = "2/3"
                self.nextButton.isEnabled = true
                self.nextButton.setTitle("Next", for: .normal)
                self.backButton.alpha = 1
                self.backButton.isEnabled = true
                self.setupInfoText()
                UIView.animate(withDuration: 0.3) {
                    self.infoText.alpha = 1
                }
            }
        case 2:
            UIView.animate(withDuration: 0.3) {
                self.infoText.alpha = 0
            } completion: { _ in
                self.secondaryLabel.text = "3/3"
                self.nextButton.isEnabled = true
                self.nextButton.setTitle("Finish", for: .normal)
                self.backButton.alpha = 1
                self.backButton.isEnabled = true
                self.setupInfoText()
                UIView.animate(withDuration: 0.3) {
                    self.infoText.alpha = 1
                }
            }
        case 3:
            handleFinish()
        default:
            break
        }
    }
    
    func setupInfoText() {
        infoStrings.removeAll()
        switch currentState {
        case 0:
            infoStrings.append(category.questions[0].questionInfo)
            infoStrings.append(category.questions[1].questionInfo)
            infoStrings.append(category.questions[2].questionInfo)
            infoStrings.append(category.questions[3].questionInfo)
        case 1:
            infoStrings.append(category.questions[4].questionInfo)
            infoStrings.append(category.questions[5].questionInfo)
            infoStrings.append(category.questions[6].questionInfo)
        case 2:
            infoStrings.append(category.questions[7].questionInfo)
            infoStrings.append(category.questions[8].questionInfo)
            infoStrings.append(category.questions[9].questionInfo)
        default:
            break
        }

        
        let bulletPoint = "•  "
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 6
        paragraphStyle.headIndent = 15

        let attributedText = NSMutableAttributedString()
        
        for str in infoStrings {
            let formattedFact = "\(bulletPoint)\(str)\n"
            let attributedString = NSAttributedString(
                string: formattedFact,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                    .foregroundColor: UIColor.customPurple,
                    .paragraphStyle: paragraphStyle
                ]
            )
            attributedText.append(attributedString)
        }
        
        infoText.attributedText = attributedText
    }
    
    private func handleFinish() {
        SportsDB.shared.updateFavourite(for: category.category, isCompleted: true)
        complitionHandler?()
        navigationController?.popViewController(animated: true)
    }
}
