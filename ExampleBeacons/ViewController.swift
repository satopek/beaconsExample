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


  var beacons = [CLBeaconRegion]()
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupLocation()
    setupBeacons()


  }

  func setupLocation() {

    self.locationManager.delegate = self

    self.locationManager.requestWhenInUseAuthorization()
  }

  func setupBeacons() {
    let beaconPurple = CLBeaconRegion(
      proximityUUID: NSUUID(uuidString: "27690087-FB67-F3FD-0B0D-1E66E30D636E")! as UUID, identifier: "Beacon: IntelLumen")

    self.locationManager.startMonitoring(for: beaconPurple)
    self.locationManager.requestState(for: beaconPurple)
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

    case .authorizedWhenInUse:

      self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.locationManager.startUpdatingLocation()
      self.setupLocation()
      self.setupBeacons()

    case .denied:

      let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.alert)
      let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in }
      alert.addAction(alertAction)

      removeRegions()

    default:
      print("default case")
      
    }
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    print(beacons)
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
      
      let text = "inside range"
      
      print("\(text): \(region.identifier)")
    case .outside:
      let text = "outside range"
      print("\(text): \(region.identifier)")
    }
  }
}
