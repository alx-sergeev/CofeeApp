//
//  OrderTableViewCell.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 15.02.2024.
//

import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    weak var delegate: OrderViewControllerDelegate?
    
    private let coreDataManager = CoreDataManager.shared
    private var product: Product?
    
    private let contentViewCell = UIView()
    private let hStack = UIStackView()
    
    private let leftVStack = UIStackView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let rightHStack = UIStackView()
    private let minusButton = UIButton(type: .system)
    private let cntLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    
    func configure(item: Product, delegate: OrderViewControllerDelegate) {
        self.delegate = delegate
        
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
        
        selectionStyle = .none
    }
}

// MARK: - Setup actions
extension OrderTableViewCell {
    private func setupViews() {
        contentView.addViews(contentViewCell, hStack)
        
        hStack.addArrangedSubview(leftVStack)
        hStack.addArrangedSubview(rightHStack)

        leftVStack.addArrangedSubview(nameLabel)
        leftVStack.addArrangedSubview(priceLabel)

        rightHStack.addArrangedSubview(minusButton)
        rightHStack.addArrangedSubview(cntLabel)
        rightHStack.addArrangedSubview(plusButton)
    }
    
    private func constraintViews() {
        contentViewCell.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
        
        hStack.snp.makeConstraints { make in
            make.top.equalTo(contentViewCell.snp.top).inset(14)
            make.bottom.equalTo(contentViewCell.snp.bottom).inset(14)
            make.leading.equalTo(contentViewCell.snp.leading).inset(10)
            make.trailing.equalTo(contentViewCell.snp.trailing).inset(10)
            
        }

        rightHStack.snp.makeConstraints { make in
            make.width.equalTo(76)
        }
    }
    
    func configureAppearance() {
        // View
        backgroundColor = .white

        // Content view
        contentViewCell.backgroundColor = .tableCellBackgroundColor
        contentViewCell.layer.cornerRadius = 5
        contentViewCell.layer.shadowColor = UIColor.black.cgColor
        contentViewCell.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentViewCell.layer.shadowRadius = 2
        contentViewCell.layer.shadowOpacity = 0.25
        
        // Main stack
        hStack.distribution = .fillProportionally
        hStack.spacing = 12

        // Left stack
        leftVStack.axis = .vertical
        leftVStack.distribution = .equalSpacing
        leftVStack.spacing = 4

        // Product name
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .textDefaultColor

        // Product price
        priceLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.textColor = .textSecondColor

        // Right stack
        rightHStack.distribution = .equalSpacing

        // Button minus
        minusButton.setImage(UIImage(named: "minus_bold_icon"), for: .normal)
        minusButton.tintColor = .textDefaultColor

        // Count label
        cntLabel.font = .systemFont(ofSize: 16, weight: .bold)
        cntLabel.textColor = .textDefaultColor

        // Button plus
        plusButton.setImage(UIImage(named: "plus_bold_icon"), for: .normal)
        plusButton.tintColor = .textDefaultColor
    }
}

// MARK: - Calc actions
extension OrderTableViewCell {
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
                delegate?.deleteRowAction(itemId: product.id)
            }
        } else {
            coreDataManager.create(item: product, count: count)
        }
    }
}
