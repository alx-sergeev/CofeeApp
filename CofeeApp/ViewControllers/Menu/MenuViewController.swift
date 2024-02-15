//
//  MenuViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 12.02.2024.
//

import UIKit
import SDWebImage

class MenuViewController: BaseViewController {
    private let apiService = ApiService.shared
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    }()
    
    private let collectionViewCellID = "productCell"
    private let padding: CGFloat = 16
    private let itemHeight: CGFloat = 205
    
    
    private let orderButton: UIButton = .createButton(title: "Перейти к оплате")
    private let orderButtonHeight: Int = 48
    
//    private let items: [Product] = [
//        .init(id: 1, name: "Эспрессо", imageURL: "https://upload.wikimedia.org/wikipedia/commons/9/9a/Espresso_and_napolitains.jpg", price: 110),
//        .init(id: 2, name: "Капучино", imageURL: "https://upload.wikimedia.org/wikipedia/commons/1/16/Classic_Cappuccino.jpg", price: 180),
//        .init(id: 3, name: "Горячий шоколад", imageURL: "https://upload.wikimedia.org/wikipedia/commons/e/e9/Hei%C3%9Fe_Schokolade.jpg", price: 220),
//        .init(id: 4, name: "Эспрессо", imageURL: "https://upload.wikimedia.org/wikipedia/commons/9/9a/Espresso_and_napolitains.jpg", price: 110),
//        .init(id: 5, name: "Капучино", imageURL: "https://upload.wikimedia.org/wikipedia/commons/1/16/Classic_Cappuccino.jpg", price: 180),
//        .init(id: 6, name: "Горячий шоколад", imageURL: "https://upload.wikimedia.org/wikipedia/commons/e/e9/Hei%C3%9Fe_Schokolade.jpg", price: 220)
//    ]
    var cafeId: Int?
    private var items: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Меню"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        
        getMenu()
    }
    
    
    private func getMenu() {
        guard let id = cafeId else { return }
        
        apiService.getMenuByID(id) { [weak self] products in
            self?.items = products
        }
    }
}

// MARK: - Setup actions
extension MenuViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addViews(collectionView, orderButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(orderButton.snp.top)
        }
        
        orderButton.snp.makeConstraints { make in
            make.height.equalTo(orderButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(padding)
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        collectionView.backgroundColor = .white
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        
        guard let imagePath = item.imageURL, let imageUrl = URL(string: imagePath) else {
            return UICollectionViewCell()
        }
        cell.imageView.sd_setImage(with: imageUrl)
        
        cell.configure(item: item)
        
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth: CGFloat = padding * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let itemWidth: CGFloat = availableWidth / itemsPerRow
        
        return .init(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}
