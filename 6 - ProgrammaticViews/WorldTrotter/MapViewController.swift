//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by 전소영 on 2021/06/16.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation: MKUserLocation?
    var changedPin = 0
    
    let zoomButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "MapIcon"), for: .normal)
        button.addTarget(self, action: #selector(zoom), for: .touchUpInside)
        return button
    }()
    
    let locationChangeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ConvertIcon"), for: .normal)
        button.addTarget(self, action: #selector(changeLocationPin), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        view.addSubview(zoomButton)
        setUpZoomButtonLayout()
        
        view.addSubview(locationChangeButton)
        setUpLocationChangeButtonLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        userLocation = mapView.userLocation
        addAnnotation()
    }
    
    func setUpZoomButtonLayout() {
        zoomButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        zoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        zoomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func setUpLocationChangeButtonLayout() {
        locationChangeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        locationChangeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        locationChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        locationChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    @objc func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @objc func zoom() {
        //현재 위치 가져오기
        guard let location = userLocation else {
            return
        }
        
        //현재 위치를 기준으로 영역을 생성
        let region = MKCoordinateRegion(center: location.location!.coordinate, latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        //맵 뷰의 영역을 설정
        mapView.setRegion(region, animated: true)
    }
    
    @objc func changeLocationPin() {
        guard let location = userLocation else {
            return
        }

        var center = CLLocationCoordinate2D()
        print("changedPin: \(changedPin)")
        switch changedPin {
        case 0:
            center = CLLocationCoordinate2D(latitude: 37.6658609, longitude: 127.0317674)
        case 1:
            center = CLLocationCoordinate2D(latitude: 37.6176125, longitude: 126.9227004)
        case 2:
            center = location.location!.coordinate
        default:
            break
        }
        
        if changedPin < 2 {
            changedPin += 1
        } else {
            changedPin = 0
        }
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation() {
        guard let location = userLocation else {
            return
        }
        
        mapView.addAnnotation(createAnnotation(title: "태어난 곳", coordinate: CLLocationCoordinate2D(latitude: 37.6658609, longitude: 127.0317674)))
        
        mapView.addAnnotation(createAnnotation(title: "가본 곳", coordinate: CLLocationCoordinate2D(latitude: 37.6176125, longitude: 126.9227004)))
        
        mapView.addAnnotation(createAnnotation(title: "현재", coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
    }
    
    func createAnnotation(title: String, coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = coordinate
        return point
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        // 위치정보 반환
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        // MKCoordinateSpan -- 지도 scale
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))

        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(createAnnotation(title: "현재", coordinate: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)))
        
        locationManager.stopUpdatingLocation()
    }
}
