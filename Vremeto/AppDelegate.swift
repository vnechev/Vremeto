//
//  AppDelegate.swift
//  Vremeto
//
//  Created by Vasil Nechev on 3.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Cocoa
import SwiftSky
import CoreLocation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CLLocationManagerDelegate {

 static let stausItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let  locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
//My comment
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
        
        AppDelegate.stausItem.button?.title = "--°"
        AppDelegate.stausItem.action = #selector(AppDelegate.popUpDisplay(_:))
        let updateTimer = Timer.scheduledTimer(timeInterval: 15 * 60, target: self, selector: #selector(AppDelegate.downloadWeatherData), userInfo: nil, repeats: true)
        updateTimer.tolerance = 60
//        AppDelegate.downloadWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count - 1]
        SetLocation.instance.latitude = currentLocation.coordinate.latitude
        SetLocation.instance.longitude = currentLocation.coordinate.longitude
        AppDelegate.downloadWeatherData()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
        currentLocation = newLocation
        SetLocation.instance.latitude = currentLocation.coordinate.latitude
        SetLocation.instance.longitude = currentLocation.coordinate.longitude
        AppDelegate.downloadWeatherData()
    }
    
    @objc static func downloadWeatherData(){
     
        SwiftSky.secret = API_KEY
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.speed = .meterPerSecond
        SwiftSky.units.pressure = .hectopascal
        SwiftSky.language = .bulgarian
        
        SwiftSky.get([.current], at: location) { (result) in
            AppDelegate.stausItem.button?.title = (result.response?.current?.temperature?.current?.label ?? "__°")
            
//            NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
         
        }
        
    }

  
    
    

    @objc func popUpDisplay(_ sender: AnyObject?){
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("vc")) as? NSViewController else {return}
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        
        popoverView.show(relativeTo: (AppDelegate.stausItem.button?.bounds)!, of: AppDelegate.stausItem.button!, preferredEdge: .minY)
        
    }
}

