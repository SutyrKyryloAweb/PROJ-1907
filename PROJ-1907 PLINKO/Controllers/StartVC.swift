import UIKit

class StartVC: UIViewController {
    
    let footballImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Football")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let baseballImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Baseball")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let tennisImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Tennis")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rugbyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rugby")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let badmintonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Badminton")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "defaultButton"), for: .normal)
        button.titleLabel?.text = "Play"
        button.setTitleColor( .white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let testView: AnimatedBorderView = {
        let view = AnimatedBorderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    
    override func viewDidLoad() {
        addBackground()
        setupUI()
        animateImages()
    }
    
    func setupUI() {
        view.addSubview(footballImage)
        view.addSubview(tennisImage)
        view.addSubview(rugbyImage)
        view.addSubview(badmintonImage)
        view.addSubview(baseballImage)
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            
            baseballImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            baseballImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            baseballImage.widthAnchor.constraint(equalToConstant: 74),
            baseballImage.heightAnchor.constraint(equalToConstant: 72.2),
            
            tennisImage.topAnchor.constraint(equalTo: baseballImage.topAnchor, constant: 10),
            tennisImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tennisImage.widthAnchor.constraint(equalToConstant: 100),
            tennisImage.heightAnchor.constraint(equalToConstant: 100),
            
            footballImage.topAnchor.constraint(equalTo: tennisImage.bottomAnchor, constant: 50),
            footballImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            footballImage.widthAnchor.constraint(equalToConstant: 124),
            footballImage.heightAnchor.constraint(equalToConstant: 124),
            
            badmintonImage.topAnchor.constraint(equalTo: footballImage.bottomAnchor, constant: 30),
            badmintonImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            badmintonImage.widthAnchor.constraint(equalToConstant: 124),
            badmintonImage.heightAnchor.constraint(equalToConstant: 124),
            
            rugbyImage.topAnchor.constraint(equalTo: badmintonImage.bottomAnchor, constant: 10),
            rugbyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rugbyImage.widthAnchor.constraint(equalToConstant: 111),
            rugbyImage.heightAnchor.constraint(equalToConstant: 72),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 362),
            playButton.heightAnchor.constraint(equalToConstant: 64),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func animateImages() {
        
        baseballImage.transform = CGAffineTransform(translationX: -300, y: -200)
        tennisImage.transform = CGAffineTransform(translationX: 300, y: -200)
        footballImage.transform = CGAffineTransform(translationX: -300, y: 0)
        badmintonImage.transform = CGAffineTransform(translationX: -200, y: -200)
        rugbyImage.transform = CGAffineTransform(translationX: -300, y: 200)
        playButton.transform = CGAffineTransform(translationX: 0, y: 200)
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveLinear, animations: {
            self.footballImage.transform = .identity
            self.baseballImage.transform = .identity
            self.tennisImage.transform = .identity
            self.rugbyImage.transform = .identity
            self.badmintonImage.transform = .identity
            self.playButton.transform = .identity
            
            self.badmintonImage.transform = CGAffineTransform(rotationAngle: self.convertDegreesToRadians(degrees: -173))
            self.rugbyImage.transform = CGAffineTransform(rotationAngle: self.convertDegreesToRadians(degrees: 17.25))
        })

    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    func convertDegreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees / 180 * .pi
    }
}
