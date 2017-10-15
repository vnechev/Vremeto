//
//  ViewController.swift
//  Vremeto
//
//  Created by Vasil Nechev on 3.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Cocoa
import SwiftSky
import CoreLocation

class ViewController: NSViewController {
   
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet weak var currentTempLbl: NSTextField!
    @IBOutlet weak var currenWeatherSummaryLbl: NSTextField!
    @IBOutlet weak var currentWeatherImg: NSImageView!
    @IBOutlet weak var minTempLbl: NSTextField!
    @IBOutlet weak var maxTempLbl: NSTextField!
    @IBOutlet weak var windLbl: NSTextField!
    @IBOutlet weak var pressureLbl: NSTextField!
    @IBOutlet weak var humidityLbl: NSTextField!
    @IBOutlet weak var cloudCoverLbl: NSTextField!
    @IBOutlet weak var dewPointLbl: NSTextField!
    @IBOutlet weak var uvIndexLbl: NSTextField!
    @IBOutlet weak var dateLbl: NSTextField!
    
    @IBOutlet weak var currentLocationName: NSTextField!
    @IBOutlet weak var streetNameLbl: NSTextField!
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentWeatherImg.toolTip = "Натиснете за детайлна почасова прогноза."
        self.view.layer?.cornerRadius = 6
        getCurrentData { }
        getForecast { }
        
    }

    
    override func viewDidAppear() {
//        NotificationCenter.default.addObserver(self, selector: #selector (ViewController.dataDownloadedNotif(notif: )), name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        let currentLocation = CLLocation(latitude: SetLocation.instance.latitude, longitude: SetLocation.instance.longitude)
        geocoder.reverseGeocodeLocation(currentLocation) { (placemakers, error) in
            self.geoName(withPlacemakers: placemakers, error: error)
        }
    }
    
    @objc func geoName(withPlacemakers placemarks: [CLPlacemark]?, error: Error?){
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            currentLocationName.stringValue = "N/A"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                currentLocationName.stringValue = placemark.locality!
                streetNameLbl.stringValue = placemark.thoroughfare!
            } else {
                currentLocationName.stringValue = "N/A"
            }
        }
    }
    
    @objc func dataDownloadedNotif(notif: Notification)  {
        
        AppDelegate.downloadWeatherData()
        getCurrentData { }
        getForecast { }
    }
    
    override func viewDidDisappear() {
//        NotificationCenter.default.removeObserver(self, name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
    }
    
    @IBAction func poweredByDarkSkyBtnClicked(_ sender: Any) {
        let url = URL(string: API_HOMEPAGE)
        NSWorkspace.shared.open(url!)
    }
    
    
    @IBAction func quitBtnClicked(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }
    
   @IBAction func reloadDataClicked(_ sender: Any) {
        AppDelegate.downloadWeatherData()
        getCurrentData { }
        getForecast { }
        
    }
    
    
    func getCurrentData(complete: @escaping DownloadComplete) {
        
        SwiftSky.secret = API_KEY
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.speed = .meterPerSecond
        SwiftSky.units.pressure = .hectopascal
        SwiftSky.language = .bulgarian
        
        SwiftSky.get([.current, .days, .hours], at: location) { (result) in
            self.currentTempLbl.stringValue = (result.response?.current?.temperature?.current?.label ?? "N/A")
            self.currenWeatherSummaryLbl.stringValue = (result.response?.current?.summary ?? "N/A")
            self.currentWeatherImg.image = NSImage(imageLiteralResourceName: "\(result.response?.current?.icon ?? "clear-day")")
            self.windLbl.stringValue = "Вятър: \(result.response?.current?.wind?.speed?.label ?? "N/A")"
            self.pressureLbl.stringValue = "Налягане: \(result.response?.current?.pressure?.label ?? "N/A")"
            self.humidityLbl.stringValue = "Влажност: \(result.response?.current?.humidity?.label ?? "N/A")"
            self.uvIndexLbl.stringValue = "Вероятност за валежи: \(result.response?.current?.precipitation?.probability?.label ?? "N/A") "
//            "UV индекс: \(result.response?.current?.uvIndex ?? 0)"
            self.cloudCoverLbl.stringValue = "Облачност: \(result.response?.current?.cloudCover?.label ?? "N/A")"
            self.dewPointLbl.stringValue = "Валежи при: \(result.response?.current?.dewPoint?.label ?? "N/A")"
            
            let dateFormater  = DateFormatter()
            dateFormater.locale = Locale(identifier: "bg_BG")
            dateFormater.dateFormat = "EEEE - dd.MM.yyyy"
            let currentDate = dateFormater.string(from: (result.response?.days?.points[0].time) ?? Date())
            self.dateLbl.stringValue = currentDate.capitalized
          let test = result.response?.current?.wind?.bearing?.degrees
        
//            print(test!)
        }
        
        complete()
    }
    func getForecast(complete: @escaping DownloadComplete){
        SwiftSky.secret = API_KEY
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.speed = .meterPerSecond
        SwiftSky.units.pressure = .hectopascal
        SwiftSky.language = .bulgarian
        SwiftSky.hourAmount = .hundredSixtyEight

        SwiftSky.get([.days], at: location) { (result) in
            self.minTempLbl.stringValue = "min \(result.response?.days?.points[0].temperature?.min?.label ?? "N/A")"
            self.maxTempLbl.stringValue = "max \(result.response?.days?.points[0].temperature?.max?.label ?? "N/A")"
           
        }
        
        complete()
        
    }

}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let forecastItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ForecastItem"), for: indexPath)
        
        guard let forecastCell = forecastItem as? ForecastItem else {
            return forecastItem
        }
    
        forecastCell.getForecastData(day: indexPath.section) {}
        
        return forecastCell
    }
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 5
    
    }
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 125, height: 125)
    }
    
    
}

