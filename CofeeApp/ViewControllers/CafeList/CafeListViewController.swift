//
//  CofeeListViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import UIKit
import SnapKit
import CoreLocation

class CafeListViewController: BaseViewController {
    private let apiService = ApiService.shared
    
    private let locationManager = CLLocationManager()
    private(set) var userLocation: CLLocation? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    private let cellID = "cafeCell"
    
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
        
        // Location
        startupLocation()
        
        // Get list
        getLocationList()
    }
    
    private func startupLocation() {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func getLocationList() {
        apiService.getLocationList { [weak self] items in
            self?.items = items
        }
    }
    
    private func getDistanceForCell(item: Cafe) -> String {
        guard let userLocation = userLocation,
              let cafeLat = Double(item.point.latitude),
              let cafeLong = Double(item.point.longitude)
        else { return "" }

        let cafeLocation = CLLocation(latitude: cafeLat, longitude: cafeLong)
        let distance = userLocation.distance(from: cafeLocation)
        
        return String(format: "%.0f км от вас", distance)
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

// MARK: - CLLocationManagerDelegate
extension CafeListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
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
        let distanceString = getDistanceForCell(item: cafeItem)
        cell.configure(item: cafeItem, distance: distanceString)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CafeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuVC = MenuViewController()
        let itemSelected = items[indexPath.row]
        menuVC.cafeId = itemSelected.id
        
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}

// MARK: - Actions
extension CafeListViewController {
    @objc
    private func mapButtonPressed() {
        guard !items.isEmpty else { return }
        
        let mapVC = MapViewController()
        mapVC.cafeItems = items
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}
