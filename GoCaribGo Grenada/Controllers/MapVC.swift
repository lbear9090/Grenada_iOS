
//
//  MapVC.swift
//  GoCaribGo Grenada
//
//  Created by DevoGuru on 24/04/18.
//  Copyright © 2018 The RedBox Agency. All rights reserved.
//

import UIKit
import Mapbox

class MapVC: UIViewController,MGLMapViewDelegate {

    @IBOutlet var myview: UIView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addMap()
    }
    

    func addMap()  {
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        myview.addSubview(mapView)
        
        
        addAnnotation(mapView: mapView)
    }
    
    
    func addAnnotation( mapView: MGLMapView)
    {
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude:  59.31, longitude: 18.06)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - MGLMapViewDelegate
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

     // MARK: - UIButton
    
    @IBAction func btnBack_Click(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
        
    }
}
