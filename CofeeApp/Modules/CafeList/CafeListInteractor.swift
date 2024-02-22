//
//  CafeListInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import CoreLocation

protocol CafeListInteractorProtocol: AnyObject {
    func onFetchLocations(completion: @escaping ([Cafe]) -> ())
    func onGetDistance(item: Cafe, userLocation: CLLocation) -> String
}

class CafeListInteractor {
    weak var presenter: CafeListPresenterProtocol?
    
    private let apiService = ApiService.shared
}

extension CafeListInteractor: CafeListInteractorProtocol {
    func onFetchLocations(completion: @escaping ([Cafe]) -> ()) {
        apiService.getLocationList { items in
            completion(items)
        }
    }
    
    func onGetDistance(item: Cafe, userLocation: CLLocation) -> String {
        guard let cafeLat = Double(item.point.latitude), let cafeLong = Double(item.point.longitude) else {
            return ""
        }

        let cafeLocation = CLLocation(latitude: cafeLat, longitude: cafeLong)
        let distanceM = userLocation.distance(from: cafeLocation)
        
        // В метрах
        if distanceM < 1000 {
            return String(format: "%.0f м от вас", distanceM)
        }
        
        // В километрах
        let distanceKM: Double = distanceM / 1000
        return String(format: "%.0f км от вас", distanceKM)
    }
}
