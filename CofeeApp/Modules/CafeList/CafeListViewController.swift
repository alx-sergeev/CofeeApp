//
//  CofeeListViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit
import SnapKit

protocol CafeListViewProtocol: AnyObject {
    func onSetItems(_ items: [Cafe])
}

class CafeListViewController: BaseViewController {
    var presenter: CafeListPresenter?
    
    private let tableView = UITableView()
    private let cellID = "cafeCell"
    private let tableVisibleCellCount: CGFloat = 6
    private let tableCellHeight: CGFloat = 77
    private var tableHeight: CGFloat {
        tableVisibleCellCount * tableCellHeight
    }
    
    private let mapButton: UIButton = .createButton(title: "На карте")
    private let mapButtonHeight: Int = 48
    
    private var items: [Cafe] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ближайшие кофейни"
        
        presenter?.onViewDidLoad()
    }
}

// MARK: - CafeListViewProtocol
extension CafeListViewController: CafeListViewProtocol {
    func onSetItems(_ items: [Cafe]) {
        DispatchQueue.main.async {
            self.items = items
        }
    }
}

// MARK: - Setup actions
extension CafeListViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addViews(tableView, mapButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            make.height.equalTo(tableHeight)
        }
        
        mapButton.snp.makeConstraints { make in
            make.height.equalTo(mapButtonHeight)
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
        tableView.register(CafeTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        
        // Button
        mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource
extension CafeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CafeTableViewCell else {
            return UITableViewCell()
        }
        
        let cafeItem = items[indexPath.row]
        let distanceString = presenter?.onGetDistanceForCell(item: cafeItem) ?? ""
        cell.configure(item: cafeItem, distance: distanceString)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CafeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemSelectedId = items[indexPath.row].id
        presenter?.onSelectedRow(with: itemSelectedId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellHeight
    }
}

// MARK: - Actions
extension CafeListViewController {
    @objc
    private func mapButtonPressed() {
        presenter?.onMapButtonAction(items: items)
    }
}
