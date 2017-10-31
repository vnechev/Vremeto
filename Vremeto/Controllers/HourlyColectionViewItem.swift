//
//  HourlyColectionViewItem.swift
//  Vremeto
//
//  Created by Vasil Nechev on 24.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Cocoa
import SwiftSky

class HourlyColectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var dateTimeLbl: NSTextField!
    @IBOutlet weak var hourlyImage: NSImageView!
    
    @IBOutlet weak var hourlyRainLbl: NSTextField!
    @IBOutlet weak var hourlyCurrentTempLbl: NSTextField!
    @IBOutlet weak var sumarryLabel: NSTextField!
    static var instance = HourlyColectionViewItem()
    let hour : [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 8
//        getForecastData(hour: 1 ){}
    }
    
   
    
    func getForecastData(hour: Int, complete: @escaping DownloadComplete) {
        SwiftSky.secret = API_KEY
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.speed = .meterPerSecond
        SwiftSky.units.pressure = .hectopascal
        SwiftSky.language = .bulgarian
        SwiftSky.hourAmount = .hundredSixtyEight
        SwiftSky.get([.current, .days, .hours], at: location) { (result) in
            
            let dateFormater  = DateFormatter()
            dateFormater.locale = Locale(identifier: "bg_BG")
            dateFormater.dateFormat = "HH:00"
            let dayForecast = result.response?.hours?.points[hour].time
            
            self.dateTimeLbl.stringValue = dateFormater.string(from: dayForecast ?? Date()).capitalized
            self.sumarryLabel.stringValue = "\(result.response?.hours?.points[hour].summary ?? "N/A")"
            self.hourlyImage.image = NSImage(imageLiteralResourceName: "\(result.response?.hours?.points[hour].icon ?? "clear-day")")
            self.hourlyCurrentTempLbl.stringValue = "\(result.response?.hours?.points[hour].temperature?.current?.label ?? "N/A")"
            self.hourlyRainLbl.stringValue = "Вероятност за валежи: \(result.response?.hours?.points[hour].precipitation?.probability?.label ?? "N/A") "
//            self.dayLbl.stringValue = dateFormater.string(from: dayForecast ?? Date()).capitalized
//            self.minMaxLbl.stringValue = "\(result.response?.days?.points[day].temperature?.min?.label ?? "N/A") | \(result.response?.days?.points[day].temperature?.max?.label ?? "N/A")"
//            self.hourlyForecastImg.image = NSImage(imageLiteralResourceName: "\(result.response?.hours. ?? "clear-day")")
//            self.sumarryLabel.stringValue = "\(result.response?.hours?.points[hour].temperature?.min?.label ?? "N/A") "
            
        }
       complete()
    }
}
