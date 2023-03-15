//
//  ViewController.swift
//  Project 22
//
//  Created by Евгения Зорич on 14.03.2023.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var newBeacon: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    var currentBeaconUuid: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        newBeacon.text = "not detected"
        
        myView.layer.cornerRadius = 85
        myView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
    }
     
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 0.8) {
            self.newBeacon.text = "\(name)"
            switch distance {
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.myView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.myView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.myView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.myView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func showFirst() {
            let ac = UIAlertController(title: "Beacon detected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            
            if currentBeaconUuid == nil { currentBeaconUuid = region.uuid }
            if currentBeaconUuid == region.uuid {
                update(distance: beacon.proximity, name: region.identifier)
                showFirst()
            } else { return }
        } else {
            update(distance: .unknown, name: "not detected")
        }
    }
}

