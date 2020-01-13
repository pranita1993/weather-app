//
//  ViewController.swift
//  11
//
//  Created by Student P_04 on 11/01/20.
//  Copyright © 2020 Felix ITs. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate {
    var lati = Double()
    var long = Double()
    enum jsonErrors:Error {
        case dataError
        case conversionError
    }
   // let locationmanager = CLLocationManager()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var humidity: UILabel!

    @IBOutlet weak var temparature: UILabel!

    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var des: UILabel!
    
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        Parsejson()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func Parsejson()
    {
        let urlstring = "https://api.openweathermap.org/data/2.5/weather?lat=\(lati)&lon=\(long)&appid=80cd251c4c1e0c2b6d2e78deaa97fba9"
        
        let url = URL(string: urlstring)
        let session = URLSession(configuration:.default)
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            do
            {
                
                guard let data = data else
                {
                    throw jsonErrors.dataError
                }
                guard  let coord = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any]
                    else{
                        throw jsonErrors.conversionError
                }
                let weatherArray = coord["weather"] as! [[String:Any]]
                let weatherDic = weatherArray.last!
                let descriptionstr = weatherDic["description"]as!String
                print(descriptionstr)
                self.des.text = descriptionstr
                let weatherDic1 = coord["main"] as! [String:Any]
                let temp = weatherDic1["temp"] as! NSNumber
                let tem = Double(trunc(Double(temp)))
                print(tem)
                self.temparature.text = String(tem)
                let humiditys = weatherDic1["humidity"] as! NSNumber
                let hum = Double (trunc(Double(humiditys)))
                print(hum)
                self.humidity.text = String(hum)
                let names = coord["name"] as! String
                print(names)
                self.name.text = names
                
            }
            catch jsonErrors.dataError
            {
                print("dataerror\(error?.localizedDescription)")
            }
            catch jsonErrors.conversionError
            {
                print("conversionerror\(error?.localizedDescription)")
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
        
        
    }
   /* func detectlocation()
    {
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
    }*/
   // forwordgeocode
   /* func locationManger(_manger:CLLocationManager,didUpadateLocation locations:[CLLocation])
    {
     let currentlocation = locations.last!
        let lattitude = currentlocation.coordinate.latitude
        let longitude = currentlocation.coordinate.longitude
        print("latitude = \(lattitude) and longitude = \( longitude) ")
        lati = lattitude
        long = longitude
      locationmanager.stopUpdatingLocation()
        let span = MKCoordinateSpanMake(0.01, 0.01)
       let region = MKCoordinateRegionMake(currentlocation.coordinate, span)
        mapview.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentlocation.coordinate
       
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentlocation) { (placemarks, error) in
            guard let placemark:CLPlacemark = placemarks?.first else
            {
                return
            }
            let country = placemark.country
            annotation.title = country
            self.mapview.addAnnotation(annotation)
            
        }
        
        
        
    }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let geo = CLGeocoder()
        geo.geocodeAddressString(searchText.text!) { (placeMarks, error) in
            let placeMark = placeMarks?.first
            self.lati = (placeMark?.location?.coordinate.latitude)!
            self.long = (placeMark?.location?.coordinate.longitude)!
            let coordinate = placeMark?.location?.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate!
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            //mapView.setRegion(region, animated: true)
            self.mapview.setRegion(region, animated: true)
            let title = placeMark?.name
            annotation.title = title
            self.mapview.addAnnotation(annotation)
           // mapView.addAnnotation(annotation)
            
        }
        return true
    }

    
    @IBAction func getweather(_ sender: UIButton) {
        Parsejson()
    }

    //@IBAction func currentlocation(_ sender: UIButton) {
        //detectlocation()
   // }



}

