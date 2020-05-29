//
//  ViewController.swift
//  Map
//
//  Created by Brijesh Makwana on 13/04/1941 Saka.
//  Copyright © 1941 Brijesh Makwana. All rights reserved.

import UIKit
import Mapbox
import MapboxNavigation
import MapboxCoreNavigation
import MapboxDirections


class ViewController: UIViewController {
    let mapView = MGLMapView()
    var button: UIButton!
    var a = "mapbox://styles/xyzabc/cjwulyxts046m1cqpqgolcouh"
    var points = [CLLocationCoordinate2D]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.styleURL =  URL(string:a)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 21.7787473
            , longitude: 72.1499052), zoomLevel: 14, animated: false)
        view.addSubview(mapView)
        
      let styleToggle = UISegmentedControl(items: ["Day", "Night", "Satellite"])
      styleToggle.translatesAutoresizingMaskIntoConstraints = false
      styleToggle.tintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      styleToggle.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      styleToggle.clipsToBounds = true
      styleToggle.selectedSegmentIndex = 0
      view.insertSubview(styleToggle, aboveSubview: mapView)
      styleToggle.addTarget(self, action: #selector(changeStyle(sender:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)])
       NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 444, height: 45))
        button.setTitle("Choose your way...", for: .disabled)
        button.backgroundColor =  #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startNavigation(sender:)), for: .touchUpInside)
        button.isEnabled = false
        mapView.addSubview(button)
    }
    @objc func startNavigation(sender: UIButton) {
        
        let options = NavigationRouteOptions(coordinates: points)
        options.profileIdentifier = .automobile
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            let navigationController = NavigationViewController(for: route)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: sender.view!)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        points.append(coordinate)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        if (points.count) > 1 {
            button.backgroundColor =  #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            button.isEnabled = true
        }
    }
    //MARK:- Different Modes of Map
@objc func changeStyle(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
        mapView.tintColor = .blue
        mapView.styleURL = URL(string:"mapbox://styles/xyzabc/cjwulyxts046m1cqpqgolcouh")
    case 1:
        mapView.tintColor = .red
        mapView.styleURL = URL(string:"mapbox://styles/xyzabc/cjwum1nd6046m1cocrddo66os")
    case 2:
            mapView.tintColor = .green
            mapView.styleURL = URL(string:"mapbox://styles/xyzabc/cjxpx03ww0h0r1cp1tej2dbpi")
    default:
        mapView.styleURL = URL(string:"mapbox://styles/xyzabc/cjxoxyvw71qld1cn175oejpw0")        }
}
}
