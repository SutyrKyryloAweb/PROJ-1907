import UIKit

class TestVC: UIViewController {

    var category: QuizCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
}
