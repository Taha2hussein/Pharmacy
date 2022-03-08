//
//  MapViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay
import GoogleMaps
import GooglePlaces
class MapViewModel{
    
    private weak var view: MapViewController?
    private var router: MapRouter?
    
    func bind(view: MapViewController, router: MapRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}


extension MapViewModel: getLocationAdress {
    func getLocationAdress(_ pdblLatitude: String, _ pdblLongitude: String,completion:@escaping(String)-> Void) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                
            }
            let pm = placemarks
            
            if pm?.count ?? 0 > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                
                if pm.name != nil {
                    addressString = addressString + pm.name!
                }
                
                completion(addressString)
                
            }
            
        })
        
    }
}

extension MapViewModel: backView {
    func backNavigationview() {
        self.router?.popView()
    }
    
    
}
