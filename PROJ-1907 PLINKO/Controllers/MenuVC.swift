import UIKit

class MenuVC: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's start"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView!
    
    private let howToPlayButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "defaultButton"), for: .normal)
        button.setTitle("How to play?", for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rulesIV: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "rulesImage"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let rulesText: UILabel = {
        let label = UILabel()
        let text = """
        1. Pick a level and start!
        2. Answer questions, test your skills.
        3. Skipped question = incorrect.
        4. Check your results!
        5. Didn't pass? Try again!
        6. Open the next level in the menu.
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24
        paragraphStyle.lineSpacing = 16

        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.customPurple,
                .font: UIFont.systemFont(ofSize: 18, weight: .medium)
            ]
        )
        
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var dataSource: [QuizCategory]?
    private var isRulesSwown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        addBackground()
        setupCollectionView()
        setupRulesPage()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(howToPlayButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            howToPlayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            howToPlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            howToPlayButton.widthAnchor.constraint(equalToConstant: 362),
            howToPlayButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        howToPlayButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SportCell.self, forCellWithReuseIdentifier: "GameCell")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.isScrollEnabled = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupRulesPage() {
        view.addSubview(rulesIV)
        rulesIV.addSubview(rulesText)
        NSLayoutConstraint.activate([
            
            rulesIV.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            rulesIV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rulesIV.widthAnchor.constraint(equalToConstant: 362),
            rulesIV.heightAnchor.constraint(equalToConstant: 320),
            
            rulesText.topAnchor.constraint(equalTo: rulesIV.topAnchor,constant: 20),
            rulesText.bottomAnchor.constraint(equalTo: rulesIV.bottomAnchor,constant: -20),
            rulesText.leadingAnchor.constraint(equalTo: rulesIV.leadingAnchor,constant: 20),
            rulesText.trailingAnchor.constraint(equalTo: rulesIV.trailingAnchor,constant: -20),
        ])
        rulesIV.alpha = 0
    }
    
    func addBackground() {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
    }
    
    func fetchData() {
        dataSource = SportsDB.shared.categories
    }
    
    @objc func handleTap() {
        isRulesSwown.toggle()
        howToPlayButton.isEnabled = false
        if isRulesSwown {
            UIView.animate(withDuration: 0.3) {
                self.rulesIV.alpha = 1
                self.collectionView.alpha = 0
                self.howToPlayButton.setTitle("Ok", for: .normal)
                self.titleLabel.text = "Rules"
            } completion: { _ in
                self.howToPlayButton.isEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.rulesIV.alpha = 0
                self.collectionView.alpha = 1
                self.howToPlayButton.setTitle("How to play?", for: .normal)
                self.titleLabel.text = "Let's start"
            } completion: { _ in
                self.howToPlayButton.isEnabled = true
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let spacing: CGFloat = 4
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            func createGroup(itemCount: Int, xOffset: CGFloat) -> NSCollectionLayoutGroup {
                let totalWidth = CGFloat(itemCount) * 88 + CGFloat(itemCount - 1) * spacing
                let screenWidth = environment.container.contentSize.width
                let adjustedOffset = (screenWidth - totalWidth) / 2
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(totalWidth),
                    heightDimension: .absolute(88)
                )
                
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
                containerGroup.interItemSpacing = .fixed(spacing)
                
                return NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment -> [NSCollectionLayoutGroupCustomItem] in
                    var items: [NSCollectionLayoutGroupCustomItem] = []
                    for i in 0..<itemCount {
                        let xPos = CGFloat(i) * (88 + spacing) + adjustedOffset
                        let itemFrame = CGRect(x: xPos, y: 0, width: 88, height: 88)
                        items.append(NSCollectionLayoutGroupCustomItem(frame: itemFrame))
                    }
                    return items
                }
            }
            
            let firstRow = createGroup(itemCount: 4, xOffset: 0)
            let secondRow = createGroup(itemCount: 3, xOffset: 0)
            let thirdRow = createGroup(itemCount: 4, xOffset: 0)
            let fourthRow = createGroup(itemCount: 3, xOffset: 0)
            
            let containerGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(88 * 4 + spacing * 3)
                ),
                subitems: [firstRow, secondRow, thirdRow, fourthRow]
            )
            containerGroup.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            return section
        }
    }
}

extension MenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! SportCell
        let imageName = dataSource?[indexPath.item].category ?? ""
        let currInd = UserDefaults.standard.integer(forKey: "currentSection")
        if indexPath.row <= currInd {
            cell.configure(with: imageName)
        } else if(indexPath.row == currInd + 1) {
            cell.configure(with: "nextUnlock")
            
        } else {
            cell.configure(with: "lock")
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChooseVC()
        vc.category = dataSource?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let currentSection = UserDefaults.standard.integer(forKey: "currentSection")
        return indexPath.item <= currentSection
    }
}
