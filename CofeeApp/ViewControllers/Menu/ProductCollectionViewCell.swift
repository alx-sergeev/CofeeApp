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
    
    
    private let vStack = UIStackView()
    
    let imageView = UIImageView()
    private let imageHeight = 137
    
    private let nameLabel = UILabel()
    
    private let hBottomStack = UIStackView()
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
        addSubview(vStack)
        
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(hBottomStack)

        hBottomStack.addArrangedSubview(priceLabel)
        hBottomStack.addArrangedSubview(cntHStack)
        
        cntHStack.addArrangedSubview(minusButton)
        cntHStack.addArrangedSubview(cntLabel)
        cntHStack.addArrangedSubview(plusButton)
    }
    
    private func constraintViews() {
        vStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.top)
            make.trailing.equalTo(vStack.snp.trailing)
            make.leading.equalTo(vStack.snp.leading)
            make.height.equalTo(imageHeight)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        hBottomStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
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
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 12
        
        // Product image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Product name
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textColor = .textSecondColor
        
        // Horizontal bottom stack
        hBottomStack.axis = .horizontal
        hBottomStack.distribution = .fillEqually
        
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
