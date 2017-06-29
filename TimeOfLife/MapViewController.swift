//
//  MapViewController.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/24.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBAction func showDirection(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentTransportType = MKDirectionsTransportType.automobile
        case 1:
            currentTransportType = MKDirectionsTransportType.walking
        default:
            break
        }
        
        segmentedControl.isHidden = false
        
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        // 起始路徑與目的地
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionsRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionsRequest.transportType = currentTransportType
        
        // 方位計算
        let directions = MKDirections(request: directionsRequest)
        directions.calculate(completionHandler: {
            (routeResponse, routeError) -> Void in
            guard let RouteResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error \(routeError)")
                }
                return
            }
            
            let route = routeResponse?.routes[0]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add((route?.polyline)!, level: MKOverlayLevel.aboveRoads)
            let rect = route?.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
            
        })
        
    }
    
    
    let locationManager = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    var timeOfLife: TimeOfLifeMO!
    var currentTransportType = MKDirectionsTransportType.automobile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.isHidden = true
        
        mapView.delegate = self
        if #available(iOS 9.0, *) {
            mapView.showsScale = true
            mapView.showsCompass = true
            mapView.showsTraffic = true
        }
      
        // 獲取使用者授權使用定位功能
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(timeOfLife.address!, completionHandler: { placemarks, error in
            if error != nil {
                let alert = UIAlertController(title: "Oops.. somethingwrong. ", message: "please try another address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                let annotation = MKPointAnnotation()
                annotation.title = self.timeOfLife.area
                annotation.subtitle = self.timeOfLife.descriptions
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: timeOfLife.image as! Data)
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.blue
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
