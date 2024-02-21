//
//  OrderViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 15.02.2024.
//

import UIKit

protocol OrderViewProtocol: AnyObject {
    func onSetItems(_ items: [Product])
}

// MARK: - Protocol OrderViewControllerDelegate
protocol OrderViewControllerDelegate: AnyObject {
    func deleteRowAction(itemId: Int)
}

class OrderViewController: BaseViewController {
    var presenter: OrderPresenter?
    
    private let tableView = UITableView()
    private let cellID = "orderItemCell"
    private let tableVisibleCellCount: CGFloat = 4
    private let tableCellHeight: CGFloat = 77
    private var tableHeight: CGFloat {
        tableVisibleCellCount * tableCellHeight
    }
    
    private let vStack = UIStackView()
    private let textOrderLabel = UILabel()
    
    private let payButton: UIButton = .createButton(title: "Оплатить")
    private let payButtonHeight: Int = 48
    
    private var items: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ваш заказ"
        
        presenter?.onViewDidLoad()
    }
}

// MARK: - OrderViewProtocol
extension OrderViewController: OrderViewProtocol {
    func onSetItems(_ items: [Product]) {
        DispatchQueue.main.async {
            self.items = items
        }
    }
}

// MARK: - Setup actions
extension OrderViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addViews(tableView, vStack, payButton)
        vStack.addArrangedSubview(textOrderLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            make.height.equalTo(tableHeight)
        }
        
        vStack.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).inset(-10)
            make.bottom.equalTo(payButton.snp.top).inset(-10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(40)
        }
        
        textOrderLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        payButton.snp.makeConstraints { make in
            make.height.equalTo(payButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        // Table
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        // Text
        textOrderLabel.text = "Время ожидания заказа\n 15 минут!\n Спасибо, что выбрали нас!"
        textOrderLabel.textAlignment = .center
        textOrderLabel.numberOfLines = 0
        textOrderLabel.font = .systemFont(ofSize: 24, weight: .medium)
        textOrderLabel.textColor = .textDefaultColor
        
        // Button
        payButton.addTarget(self, action: #selector(payButtonPressed), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource
extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.item]
        cell.configure(item: item, delegate: self)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellHeight
    }
}

// MARK: - Actions
extension OrderViewController {
    @objc
    private func payButtonPressed() {
        presenter?.onPayButtonAction()
    }
}

// MARK: - OrderViewControllerDelegate
extension OrderViewController: OrderViewControllerDelegate {
    func deleteRowAction(itemId: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        
        items.remove(at: index)
        tableView.reloadData()
    }
}
