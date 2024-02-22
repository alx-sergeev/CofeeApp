//
//  MapViewController.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 11.02.2024.
//

import UIKit
import SnapKit
import YandexMapsMobile

class MapViewController: BaseViewController {
    lazy var mapView: YMKMapView = YMKMapView(frame: view.bounds)
    
    var cafeItems: [Cafe] = []
    private var resultItems: [(Cafe, YMKPoint)]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Карта"
        
        loadMapData()
    }
    
    
    private func loadMapData() {
        guard !cafeItems.isEmpty else { return }
        
        resultItems = cafeItems.compactMap { cafe -> (Cafe, YMKPoint)? in
            guard let latitude = Double(cafe.point.latitude), let longitude = Double(cafe.point.longitude) else { return nil }
            
            return (cafe, YMKPoint(latitude: latitude, longitude: longitude))
        }
        
        addPlacemarksOnMap()
        
        if let firstItem = resultItems?.first {
            let startPosition = YMKCameraPosition(target: firstItem.1, zoom: 15.0, azimuth: .zero, tilt: .zero)
            moveToPoint(position: startPosition)
        }
    }
    
    private func addPlacemarksOnMap() {
        guard let resultItems = resultItems, !resultItems.isEmpty, let image = UIImage(named: "placemark_icon") else { return }

        let map = mapView.mapWindow.map

        resultItems.enumerated().forEach { pair in
            let element = pair.element
            
            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = element.1
            placemark.setIconWith(image)
            placemark.setIconStyleWith(.init(anchor: nil, rotationType: nil, zIndex: nil, flat: nil, visible: nil, scale: 1, tappableArea: nil))

            placemark.setTextWithText(
                element.0.name,
                style: {
                    let textStyle = YMKTextStyle()
                    textStyle.color = .textDefaultColor
                    textStyle.size = 14.0
                    textStyle.placement = .bottom
                    textStyle.offset = 6.0
                    return textStyle
                }()
            )
        }
    }

    private func moveToPoint(position: YMKCameraPosition) {
        let map = mapView.mapWindow.map

        map.move(with: position)
    }
    
}

// MARK: - Setup actions
extension MapViewController {
    override func setupViews() {
        super.setupViews()
        
        view.addViews(mapView)
    }
    
    override func constraintViews() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
        }
    }
}
