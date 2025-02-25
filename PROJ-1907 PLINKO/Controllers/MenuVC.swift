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
    
    private var dataSource: [QuizCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        addBackground()
        setupCollectionView()
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
        collectionView.register(SportCell.self, forCellWithReuseIdentifier: "GameCell")
        collectionView.contentInsetAdjustmentBehavior = .always
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let spacing: CGFloat = 4
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            func createGroup(itemCount: Int, xOffset: CGFloat) -> NSCollectionLayoutGroup {
                let totalWidth = CGFloat(itemCount) * 88 + CGFloat(itemCount - 1) * spacing
                let screenWidth = environment.container.contentSize.width
                let adjustedOffset = (screenWidth - totalWidth) / 2 // Центрирование
                
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
            let secondRow = createGroup(itemCount: 3, xOffset: 0) // Теперь без смещения
            let thirdRow = createGroup(itemCount: 4, xOffset: 0)
            let fourthRow = createGroup(itemCount: 3, xOffset: 0) // Теперь без смещения
            
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
        cell.configure(with: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
