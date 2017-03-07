//
//  DAO.swift
//  AlexGoogleMaps
//
//  Created by Aditya Narayan on 3/6/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapReloadDelegate {
    func reloadMap(place: CoolMarker)
}

class DAO {
    
    static let sharedInstance = DAO()
    var markers = [CoolMarker]()
    var loadDelegate : MapReloadDelegate?
    let key = "AIzaSyA-8NkSgy56uxS6DQpjunyIIXkk82yCqq8"
    var fullString = ""
    
    func searchForPlaces(searchText: String, location: CLLocationCoordinate2D){
        
        
        let lat = location.latitude
        let long = location.longitude
        let radius = 500
        
        if searchText.contains(" "){
            let seachTextArray = searchText.components(separatedBy: " ")
            
            for string in seachTextArray {
                self.fullString.append("\(string)+")
            }
            
            self.fullString.remove(at: self.fullString.index(before: self.fullString.endIndex))
        } else{
            self.fullString = searchText
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&keyword=\(self.fullString)&key=\(self.key)"
        
        let url = URL(string: urlString)
        
        let downloadTask = URLSession(configuration: .default)
        
        let task = downloadTask.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                print("error")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("did not recieve data")
                return
            }
            
            
            do {
                let new : [String:Any] = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                
                
                if let placesArray: [NSDictionary] = new["results"] as? [NSDictionary] {
                    
                    
                    for place in placesArray{
                        
                        
                        if let name = place["name"] as? String,
                            let address = place["vicinity"] as? String,
                            let photos = place["photos"] as? [Any],
                            let photo = photos[0] as? [String:Any],
                            let geometry = place["geometry"] as? [String:Any],
                            let locationDict = geometry["location"] as? [String:Any]{
                                print(locationDict["lat"] ?? "yo nah")
                                print(locationDict["lng"] ?? "yo no")
                            
                            DispatchQueue.main.async {
                               let coolMark = CoolMarker()
                                coolMark.title = name
                                coolMark.snippet = address
                                coolMark.photoRef = photo["photo_reference"] as! String?
                                coolMark.photoHeight = photo["height"] as! NSNumber?
                                coolMark.position.latitude = locationDict["lat"] as! CLLocationDegrees
                                coolMark.position.longitude = locationDict["lng"] as! CLLocationDegrees
                                self.markers.append(coolMark)
                                self.loadDelegate?.reloadMap(place: coolMark)
                            }
                                
                        }

                    }
                }
                
                
            } catch  {
                print("error converting data to JSON")
            }
            
        
        }
        task.resume()
        //self.loadDelegate?.reloadMap()
    }
    
    
    func downloadImageData(urlString: String, marker: CoolMarker){
        
        let url = URL(string: urlString)!
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        marker.image = image
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    
}













