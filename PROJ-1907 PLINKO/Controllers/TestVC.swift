import UIKit

class TestVC: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .baloo2(.bold, size: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "1/5"
        label.textColor = .white
        label.font = .baloo2(.bold, size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "questionImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let finalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "questionImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let questionText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = .baloo2(.semiBold, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finalFirstText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = .baloo2(.extraBold, size: 32)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let finalSecondText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = .baloo2(.medium, size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let finalThirdText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = .baloo2(.bold, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let firstAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .baloo2(.medium, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    private let secondAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .baloo2(.medium, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        button.titleLabel?.numberOfLines = 1
        button.tag = 1
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "transperantButton"), for: .normal)
        button.setTitle("Home page", for: .normal)
        button.setTitleColor(.customPink, for: .normal)
        button.titleLabel?.font = .baloo2(.bold, size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private let thirdAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .baloo2(.medium, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    private let fourthAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .baloo2(.medium, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.7
        button.titleLabel?.numberOfLines = 1
        return button
    }()
    
    
    var category: QuizCategory!
    var questions: [QuizQuestion]!
    var currQuestion = 0
    var correctAnswer = ""
    var answers: [String] = []
    var answerButtons: [UIButton] = []
    private var score = 0
    var isLast: Bool = false
    
    var placeholderIcon: UIImageView!
    var icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        answerButtons = [firstAnswerButton, secondAnswerButton, thirdAnswerButton, fourthAnswerButton]
        addBackground()
        questions = category.questions.shuffled()
        
        setupUI()
        setupQuestion()
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(secondaryLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(backButton)
        
        placeholderIcon = UIImageView(image: UIImage(named: "levelImage"))
        placeholderIcon.translatesAutoresizingMaskIntoConstraints = false
        
        icon = UIImageView(image: UIImage(named: "\(category.category)"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        
        placeholderImageView.addSubview(placeholderIcon)
        placeholderIcon.addSubview(icon)
        placeholderImageView.addSubview(questionText)
        placeholderImageView.addSubview(firstAnswerButton)
        placeholderImageView.addSubview(secondAnswerButton)
        placeholderImageView.addSubview(thirdAnswerButton)
        placeholderImageView.addSubview(fourthAnswerButton)
        
        placeholderImageView.addSubview(finalImageView)
        placeholderImageView.sendSubviewToBack(finalImageView)
        placeholderImageView.addSubview(finalFirstText)
        placeholderImageView.addSubview(finalSecondText)
        placeholderImageView.addSubview(finalThirdText)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 30),
            
            placeholderImageView.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 5),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 362),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 560),
            
            placeholderIcon.topAnchor.constraint(equalTo: placeholderImageView.topAnchor, constant: 10),
            placeholderIcon.widthAnchor.constraint(equalToConstant: 88),
            placeholderIcon.heightAnchor.constraint(equalToConstant: 88),
            placeholderIcon.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            icon.topAnchor.constraint(equalTo: placeholderIcon.topAnchor, constant: 15),
            icon.leadingAnchor.constraint(equalTo: placeholderIcon.leadingAnchor, constant: 15),
            icon.trailingAnchor.constraint(equalTo: placeholderIcon.trailingAnchor, constant: -15),
            icon.bottomAnchor.constraint(equalTo: placeholderIcon.bottomAnchor, constant: -15),
            
            questionText.topAnchor.constraint(equalTo: placeholderIcon.bottomAnchor, constant: 10),
            questionText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            questionText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            questionText.heightAnchor.constraint(equalToConstant: 210),

            firstAnswerButton.topAnchor.constraint(equalTo: questionText.bottomAnchor, constant: 10),
            firstAnswerButton.widthAnchor.constraint(equalToConstant: 266),
            firstAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            firstAnswerButton.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            secondAnswerButton.topAnchor.constraint(equalTo: firstAnswerButton.bottomAnchor, constant: 10),
            secondAnswerButton.widthAnchor.constraint(equalToConstant: 266),
            secondAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            secondAnswerButton.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            thirdAnswerButton.topAnchor.constraint(equalTo: secondAnswerButton.bottomAnchor, constant: 10),
            thirdAnswerButton.widthAnchor.constraint(equalToConstant: 266),
            thirdAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            thirdAnswerButton.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            fourthAnswerButton.topAnchor.constraint(equalTo: thirdAnswerButton.bottomAnchor, constant: 10),
            fourthAnswerButton.widthAnchor.constraint(equalToConstant: 266),
            fourthAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            fourthAnswerButton.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            
            finalImageView.topAnchor.constraint(equalTo: placeholderImageView.topAnchor, constant: 54),
            finalImageView.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            finalImageView.widthAnchor.constraint(equalToConstant: 152),
            finalImageView.heightAnchor.constraint(equalToConstant: 152),
            
            finalFirstText.topAnchor.constraint(equalTo: finalImageView.bottomAnchor, constant: 24),
            finalFirstText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            finalFirstText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            finalFirstText.heightAnchor.constraint(equalToConstant: 40),
            
            finalSecondText.topAnchor.constraint(equalTo: finalFirstText.bottomAnchor, constant: 20),
            finalSecondText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            finalSecondText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            finalSecondText.heightAnchor.constraint(equalToConstant: 40),
            
            finalThirdText.topAnchor.constraint(equalTo: finalSecondText.bottomAnchor, constant: 20),
            finalThirdText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            finalThirdText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            finalThirdText.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 362),
            backButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        placeholderImageView.isUserInteractionEnabled = true
        titleLabel.text = category.category
        firstAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        secondAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        thirdAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        fourthAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(goToHomePage), for: .touchUpInside)
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    func setupQuestion() {
        self.answerButtons.forEach { $0.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)}
        questionText.text = questions[currQuestion].question
        correctAnswer = questions[currQuestion].answers[0]
        answers = questions[currQuestion].answers
        answers.shuffle()
        firstAnswerButton.setTitle(answers[0], for: .normal)
        secondAnswerButton.setTitle(answers[1], for: .normal)
        thirdAnswerButton.setTitle(answers[2], for: .normal)
        fourthAnswerButton.setTitle(answers[3], for: .normal)
    }
    
    @objc func answerSelected(sender: UIButton) {
        currQuestion += 1
        // var selectedButton = sender.tag
        self.answerButtons.forEach { $0.isUserInteractionEnabled = false }
        if(sender.titleLabel?.text == correctAnswer) {
            sender.setBackgroundImage(UIImage(named: "correctButton"), for: .normal)
            self.score += 1
        } else {
            sender.setBackgroundImage(UIImage(named: "wrongButton"), for: .normal)
            answerButtons.first {$0.titleLabel?.text == correctAnswer }?.setBackgroundImage(UIImage(named: "correctButton"), for: .normal)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currQuestion == 5 ? self.lastQuestionAnswered() : self.resetState()
        }
    }
    
    @objc func goToHomePage() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func resetState() {
        UIView.animate(withDuration: 0.3) {
            self.answerButtons.forEach { $0.alpha = 0 }
            self.questionText.alpha = 0
            
        } completion: { _ in
            self.setupQuestion()
            UIView.animate(withDuration: 0.3) {
                self.answerButtons.forEach { $0.alpha = 1; $0.isUserInteractionEnabled = true }
                self.questionText.alpha = 1
                self.secondaryLabel.text = "\(self.currQuestion + 1)/5"
            }
        }
        
        
    }
    
    func lastQuestionAnswered() {
        if(score > 2) {
            finalImageView.image = UIImage(named: "winIcon")
            finalFirstText.text = "Congrats! You did it!"
            finalSecondText.text = "You unlocked the next level!"
            finalThirdText.text = "\(score)/5"
            if(isLast) {
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "currentSection") + 1, forKey: "currentSection")
            }
        } else {
            finalImageView.image = UIImage(named: "loseIcon")
            finalFirstText.text = "Almost there!"
            finalSecondText.text = "Give it another shot!"
            finalThirdText.text = "\(score)/5"
        }
        
        UIView.animate(withDuration: 0.3) {
            self.questionText.alpha = 0
            self.answerButtons.forEach { $0.alpha = 0; $0.isUserInteractionEnabled = false }
            self.placeholderIcon.alpha = 0
            self.icon.alpha = 0
            self.titleLabel.alpha = 0
            self.secondaryLabel.alpha = 0
            
        } completion: { _ in
            self.titleLabel.text = "Result"
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = 1
                self.finalImageView.alpha = 1
                self.finalFirstText.alpha = 1
                self.finalSecondText.alpha = 1
                self.finalThirdText.alpha = 1
                self.backButton.alpha = 1
            }
        }
    }
}
