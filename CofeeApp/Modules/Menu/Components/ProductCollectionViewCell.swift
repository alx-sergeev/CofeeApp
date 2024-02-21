//
//  ProductCollectionViewCell.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 12.02.2024.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    private let coreDataManager = CoreDataManager.shared
    private var product: Product?
    
    
    private let mainVStack = UIStackView()
    private let bottomVStack = UIStackView()
    
    let imageView = UIImageView()
    private let imageHeight = 137
    
    private let nameLabel = UILabel()
    
    private let bottomHStack = UIStackView()
    private let priceLabel = UILabel()

    private let cntHStack = UIStackView()
    private let minusButton = UIButton(type: .system)
    private let cntLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(item: Product) {
        product = item
        nameLabel.text = item.name
        priceLabel.text = String(item.price ?? 0) + " руб"
        
        var count: Int16 = 0
        if let existItem = coreDataManager.fetchItem(with: item.id) {
            count = existItem.count
        }
        cntLabel.text = "\(count)"
        
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Calc actions
extension ProductCollectionViewCell {
    @objc
    private func minusButtonPressed() {
        guard
            let currentValueString = cntLabel.text,
            let currentValue = Int(currentValueString),
            currentValue > 0 else { return }
        
        let newValue = currentValue - 1
        cntLabel.text = String(newValue)
        
        updateProduct(count: newValue)
    }
    
    @objc
    private func plusButtonPressed() {
        guard let currentValueString = cntLabel.text, let currentValue = Int(currentValueString) else { return }

        let newValue = currentValue + 1
        cntLabel.text = String(newValue)
        
        updateProduct(count: newValue)
    }
    
    private func updateProduct(count: Int) {
        guard let product = product else { return }
        
        if let existItem = coreDataManager.fetchItem(with: product.id) {
            if count > 0 {
                coreDataManager.update(entity: existItem, count: count)
            } else {
                coreDataManager.delete(entity: existItem)
            }
        } else {
            coreDataManager.create(item: product, count: count)
        }
    }
}

// MARK: - Setup actions
extension ProductCollectionViewCell {
    private func setupViews() {
        addViews(mainVStack)
        
        mainVStack.addArrangedSubview(imageView)
        mainVStack.addArrangedSubview(bottomVStack)
        
        bottomVStack.addArrangedSubview(nameLabel)
        bottomVStack.addArrangedSubview(bottomHStack)
        bottomHStack.addArrangedSubview(priceLabel)
        bottomHStack.addArrangedSubview(cntHStack)
        
        cntHStack.addArrangedSubview(minusButton)
        cntHStack.addArrangedSubview(cntLabel)
        cntHStack.addArrangedSubview(plusButton)
    }
    
    private func constraintViews() {
        mainVStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(mainVStack.snp.top)
            make.trailing.equalTo(mainVStack.snp.trailing)
            make.leading.equalTo(mainVStack.snp.leading)
            make.height.equalTo(imageHeight)
        }
        
        bottomVStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureAppearance() {
        // View
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.25
        
        // Vertical stack
        mainVStack.axis = .vertical
        mainVStack.distribution = .fillProportionally
        
        // Bottom vertical stack
        bottomVStack.axis = .vertical
        bottomVStack.distribution = .fillEqually
        
        // Product image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Product name
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textColor = .textSecondColor
        
        // Horizontal bottom stack
        bottomHStack.axis = .horizontal
        bottomHStack.distribution = .fillEqually
        
        // Product price
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textColor = .textDefaultColor
        
        // Count stack
        cntHStack.distribution = .equalSpacing
        cntHStack.spacing = 8
        
        // Button minus
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.tintColor = .buttonTextColor
        
        // Count label
        cntLabel.font = .systemFont(ofSize: 14, weight: .regular)
        cntLabel.textColor = .textDefaultColor
        
        // Button plus
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .buttonTextColor
        
    }
}
