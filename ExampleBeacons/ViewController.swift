//
//  ViewController.swift
//  ExampleBeacons
//
//  Created by Joan Molina on 9/5/17.
//  Copyright © 2017 Identitat. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var labelBeacon: UILabel!

  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupLocation()


  }

  func setupLocation() {

    self.locationManager.delegate = self

    self.locationManager.requestAlwaysAuthorization()
  }

  func setupBeacons() {

    let beacon = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Identitat")

    beacon.notifyEntryStateOnDisplay = true
    beacon.notifyOnExit = true
    beacon.notifyOnEntry = true
    
    self.locationManager.startMonitoring(for: beacon)

  }

}

extension ViewController: CLLocationManagerDelegate {

  func removeRegions() {
    for monitoredRegion in self.locationManager.monitoredRegions {
      self.locationManager.stopMonitoring(for: monitoredRegion)
    }
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {

    case .authorizedAlways:

      self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.locationManager.startUpdatingLocation()

      self.setupBeacons()

    case .authorizedWhenInUse:

      self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.locationManager.startUpdatingLocation()

      self.setupBeacons()

    case .denied:

      let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.alert)
      let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in }
      alert.addAction(alertAction)

      removeRegions()

    default:
      break
      
    }
  }

  func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    self.locationManager.requestState(for: region)
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if beacons.count > 0 {
      print(beacons)
    }
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

    print("entering region : \(region.identifier)")

  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

    print("exiting region : \(region.identifier)")
  }


  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {

    switch state {

    case .unknown:

      print("unknown")
      
    case .inside:
      
      let text = "inside: \(region.identifier)"
      print(text)
      labelBeacon.text = text

    case .outside:

      let text = "outside: \(region.identifier)"
      print(text)
      labelBeacon.text = text
    }
  }
}
