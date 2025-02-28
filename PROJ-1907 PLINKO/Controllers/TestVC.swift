import UIKit

class TestVC: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "1/5"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    private let questionText: UILabel = {
        let label = UILabel()
        label.textColor = .customPurple
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        return button
    }()
    
    private let secondAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()
    
    private let thirdAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        return button
    }()
    
    private let fourthAnswerButton: CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(named: "answerButton"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        return button
    }()
    
    
    var category: QuizCategory!
    var questions: [QuizQuestion]!
    var currQuestion = 0
    var correctAnswer = ""
    var answers: [String] = []
    var answerButtons: [UIButton] = []
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let iconPlaceholder = UIImageView(image: UIImage(named: "levelImage"))
        iconPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(named: "\(category.category)"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        
        placeholderImageView.addSubview(iconPlaceholder)
        iconPlaceholder.addSubview(icon)
        placeholderImageView.addSubview(questionText)
        placeholderImageView.addSubview(firstAnswerButton)
        placeholderImageView.addSubview(secondAnswerButton)
        placeholderImageView.addSubview(thirdAnswerButton)
        placeholderImageView.addSubview(fourthAnswerButton)
        
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
            
            questionText.topAnchor.constraint(equalTo: iconPlaceholder.bottomAnchor, constant: 10),
            questionText.leadingAnchor.constraint(equalTo: placeholderImageView.leadingAnchor, constant: 20),
            questionText.trailingAnchor.constraint(equalTo: placeholderImageView.trailingAnchor, constant: -20),
            questionText.heightAnchor.constraint(equalToConstant: 150),

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
        ])
        placeholderImageView.isUserInteractionEnabled = true
        titleLabel.text = category.category
        firstAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        secondAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        thirdAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        fourthAnswerButton.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
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
        var selectedButton = sender.tag
        self.answerButtons.forEach { $0.isUserInteractionEnabled = false }
        if(sender.titleLabel?.text == correctAnswer) {
            sender.setBackgroundImage(UIImage(named: "correctButton"), for: .normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "wrongButton"), for: .normal)
            answerButtons.first {$0.titleLabel?.text == correctAnswer }?.setBackgroundImage(UIImage(named: "correctButton"), for: .normal)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.resetState()
        }
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
}
