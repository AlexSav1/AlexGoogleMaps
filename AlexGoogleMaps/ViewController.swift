//
//  ViewController.swift
//  AlexGoogleMaps
//
//  Created by Aditya Narayan on 3/6/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    
    let datamanager : DAO = DAO.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datamanager.loadDelegate = self
        
        //location manager stuff
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest

        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 40.709037222006089, longitude: -74.01494278579392, zoom: 12.5)
       
        self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.searchBar.delegate = self
        
        
//        let marker2 = CoolMarker(position: CLLocationCoordinate2D(latitude: 40.709037222006089, longitude: -74.01494278579392))
//        marker2.title = "TurnToTech"
//        marker2.snippet = "Australia"
//        marker2.image = UIImage(named: "australia")
//        marker2.map = self.mapView
//        marker2.infoWindowAnchor = CGPoint(x: 0.5, y: -0.25)
//        marker2.url = URL(string: "https://www.google.com")
//
//        self.datamanager.markers.append(marker2)
    }

    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = kGMSTypeNormal
            break
        case 1:
            self.mapView.mapType = kGMSTypeHybrid
            break
        case 2:
            self.mapView.mapType = kGMSTypeSatellite
            break

        default:
            self.mapView.mapType = kGMSTypeNormal
            break

        }
        
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK:
// MARK: GMSMapViewDelegate Extension
extension ViewController: GMSMapViewDelegate, MapReloadDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = Bundle.main.loadNibNamed("MyCustomMarker", owner: self, options: nil)![0] as! MyCustomMarker
        
        let myCoolMarker = marker as! CoolMarker
        
        infoWindow.title.text = marker.title
        infoWindow.descrip.text = marker.snippet
        infoWindow.imageView.image = myCoolMarker.image
        
        
        
        //download an image
//       DispatchQueue.global().async {
//
//            do {
//                let coolData:Data = try Data(contentsOf: myCoolMarker.photoUrl!)
//                DispatchQueue.main.async {
//                    infoWindow.imageView.image = UIImage(data:coolData)
//                }
//
//            } catch  {
//                print("error downloading image")
//            }
//        
//        }
        //

        
        return infoWindow
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("tapped")
        let webVC = WebViewController()
        webVC.selectedMarker = marker as? CoolMarker
        self.present(webVC, animated: true){}
        
    }
    
    func reloadMap(place: CoolMarker){
        
            place.map = self.mapView
            place.appearAnimation = kGMSMarkerAnimationPop
            place.infoWindowAnchor = CGPoint(x: 0.5, y: -0.25)
        let height = place.photoHeight?.stringValue
        
        let photoURL = "https://maps.googleapis.com/maps/api/place/photo?maxheight=\(height!)&photoreference=\(place.photoRef!)&key=\(self.datamanager.key)"
        
//        print(photoURL)
//        place.photoUrl = URL(string: photoURL)
        
        self.datamanager.downloadImageData(urlString: photoURL, marker: place)
        
        let titleForUrl = place.title?.components(separatedBy: " ")
        var fullString = ""
        
        for string in titleForUrl! {
            fullString.append("\(string)+")
        }
    
       fullString.remove(at: fullString.index(before: fullString.endIndex))
        
            place.url = URL(string:"https://www.google.com/#q=\(fullString)&*")
        
    }
    
}

// MARK:
// MARK: UISearchBarDelegate Extension

extension ViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.view.endEditing(true)
        self.mapView.clear()
        self.datamanager.searchForPlaces(searchText: self.searchBar.text!, location: self.mapView.camera.target)
        
    }
}





















