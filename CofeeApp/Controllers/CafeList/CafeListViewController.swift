//
//  CofeeListViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit
import SnapKit

class CafeListViewController: BaseViewController {
    private let apiService = ApiService.shared
    
    private let tableView = UITableView()
    private let cellID = "cafeCell"
    
    private let mapButton: UIButton = .createButton(title: "На карте")
    private let mapButtonHeight: Int = 48
    
//    private var items: [Cafe] = [
//        Cafe(id: 1, name: "Арома", point: .init(latitude: "44.43000000000000", longitude: "44.43000000000000")),
//        Cafe(id: 2, name: "Кофе есть", point: .init(latitude: "44.72452500000000", longitude: "44.72452500000000")),
//        Cafe(id: 3, name: "ЧайКофф", point: .init(latitude: "44.83000000000000", longitude: "44.83000000000000")),
//    ]
    
    private var items: [Cafe] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ближайшие кофейни"
        
        // Table
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CafeTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        
        // getList
        getLocationList()
    }
    
    
    private func getLocationList() {
        apiService.getLocationList { [weak self] items in
            self?.items = items
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(mapButton.snp.top).inset(-20)
        }
        
        mapButton.snp.makeConstraints { make in
            make.height.equalTo(mapButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
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
        cell.configure(item: cafeItem)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CafeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}
