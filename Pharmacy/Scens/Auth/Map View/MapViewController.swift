//
//  MapViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RxCocoa
import RxSwift
import RxRelay

class MapViewController: BaseViewController, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var yourLocationField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var doneButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var location : CLLocationCoordinate2D?
    private var articleDetailsViewModel = MapViewModel()
    private var router = MapRouter()
    
    // Variables
    lazy var marker = GMSMarker()
    lazy var lati = Double()
    lazy var long = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        initializeTheLocationManager()
        backButtonAction()
        doneButtonAction()
    }
 
    func initializeTheLocationManager() {
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.yourLocationField.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func  saveLocationToLocal(){
        LocalStorage().saveLocationLatitude(latitude: lati)
        LocalStorage().saveLocationLogitude(longtitude: long)
        LocalStorage().saveLocationName(locationName: yourLocationField.text ?? "")
    }
    
    func backButtonAction(){
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.backNavigationview()
        }.disposed(by: self.disposeBag)

    }
    
    func doneButtonAction(){
        doneButton.rx.tap.subscribe { [weak self] _ in
            defer {
                self?.articleDetailsViewModel.backNavigationview()
            }
            self?.saveLocationToLocal()
        } .disposed(by: self.disposeBag)

    }

    
}

extension MapViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func setMarker(_ latitude:Double,_ longitude:Double){
        marker.isDraggable = false
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.map = mapView
        marker.icon = UIImage(named:"shape956")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.last
        self.locationManager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 18.0)
        
        self.mapView?.animate(to: camera)
    }
    
    // if user change map postion
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition)  {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        lati = latitude
        long = longitude
        
        self.setMarker(latitude,longitude)
        articleDetailsViewModel.getLocationAdress("\(latitude)", "\(longitude)") {[weak self] (locations) in
            
            DispatchQueue.main.async {
                
                self?.yourLocationField.text = locations
            }
            
        }
    }

}
