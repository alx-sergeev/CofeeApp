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
        let distance = userLocation.distance(from: cafeLocation)
        
        return String(format: "%.0f км от вас", distance)
    }
}
