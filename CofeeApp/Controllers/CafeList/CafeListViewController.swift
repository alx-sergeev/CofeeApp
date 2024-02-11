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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}
