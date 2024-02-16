//
//  CafeTableViewCell.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit

class CafeTableViewCell: UITableViewCell {
    private let contentViewCell = UIView()
    
    private let vStack = UIStackView()
    private let nameLabel = UILabel()
    private let distanceLabel = UILabel()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    
    func configure(item: Cafe, distance: String = "") {
        nameLabel.text = item.name
        distanceLabel.text = distance
        
        selectionStyle = .none
    }
}

// MARK: - Setup actions
extension CafeTableViewCell {
    private func setupViews() {
        contentView.addViews(contentViewCell, vStack)
        
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(distanceLabel)
    }
    
    private func constraintViews() {
        contentViewCell.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
        
        vStack.snp.makeConstraints { make in
            make.top.equalTo(contentViewCell.snp.top).inset(14)
            make.bottom.equalTo(contentViewCell.snp.bottom).inset(14)
            make.leading.equalTo(contentViewCell.snp.leading).inset(10)
            make.trailing.equalTo(contentViewCell.snp.trailing).inset(10)
            
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
        
        // VStack
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 12
        
        // Name label
        nameLabel.textColor = .textDefaultColor
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        // Distance label
        distanceLabel.textColor = .textSecondColor
        distanceLabel.font = .systemFont(ofSize: 14)
    }
}
