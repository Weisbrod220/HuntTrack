//
//  FirstViewController.swift
//  HuntTrack
//
//  Created by Evan Weisbrod on 3/29/16.
//  Copyright © 2016 Evan Weisbrod. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import GeoFire

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LatLabel: UILabel!
    @IBOutlet weak var LongLabel: UILabel!
    var locationManager:CLLocationManager!
    let regionRadius: CLLocationDistance = 500
    let name = nameSingleton.defaults.objectForKey("Username") as? String

    let logout = "logout"
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func pintomap()
    {
        if(nameSingleton.partymembers.count != 0)
        {
            let templat = (String(nameSingleton.memberlats[0]))
            let templong = (String(nameSingleton.memberlongs[0]))
            print(templat)
            print(templong)
            let partymemberslocation = CLLocationCoordinate2DMake(Double(templat)! , Double(templong)!)
            
            let droppin = MKPointAnnotation()
            droppin.coordinate = partymemberslocation
            droppin.title = nameSingleton.partymembers[0]
            mapView.addAnnotation(droppin)
        }

    }
    override func viewDidLoad()
    {
        self.pintomap()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func getCoords(sender: AnyObject)
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    @IBAction func logoutButton(sender: AnyObject)
    {
        let myRootRef = Firebase(url: "https://hunttracker.firebaseio.com/");
        myRootRef.unauth();
        self.performSegueWithIdentifier(self.logout, sender: nil)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let latValue = locationManager.location!.coordinate.latitude
        let lonValue = locationManager.location!.coordinate.longitude
        
        LatLabel.text = String(latValue)
        LongLabel.text = String(lonValue)
        let myRootRef = Firebase(url: "https://hunttracker.firebaseio.com/users/\(name!)");
      
        let usersRoot = myRootRef.childByAppendingPath("Location")
        let geoFire = GeoFire(firebaseRef: usersRoot.childByAppendingPath("LocationData"))
    
       geoFire.setLocation(CLLocation(latitude: latValue, longitude: lonValue), forKey: "Values"){ (error) in
            if (error != nil)
            {
                print("error \(error)")
            }
            else
            {
                print("Saved location")
                self.pintomap()
            }
        }

    }

    

}


