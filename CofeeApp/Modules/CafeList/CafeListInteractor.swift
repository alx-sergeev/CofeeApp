//
//  CafeListInteractor.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

import CoreLocation

protocol CafeListInteractorProtocol: AnyObject {
    func onFetchLocations(completion: @escaping ([Cafe]) -> ())
    func onGetDistance(item: Cafe) -> String
}

class CafeListInteractor {
    weak var presenter: CafeListPresenterProtocol?
    
    private let apiService = ApiService.shared
    private let locationDataManager = LocationDataManager.shared
}

extension CafeListInteractor: CafeListInteractorProtocol {
    func onFetchLocations(completion: @escaping ([Cafe]) -> ()) {
        apiService.getLocationList { items in
            completion(items)
        }
    }
    
    func onGetDistance(item: Cafe) -> String {
        guard
            let userLocation = locationDataManager.currentLocation,
            let cafeLat = Double(item.point.latitude),
            let cafeLong = Double(item.point.longitude)
        else {
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
