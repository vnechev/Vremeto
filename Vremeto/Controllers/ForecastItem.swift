//
//  ForecastItem.swift
//  Vremeto
//
//  Created by Vasil Nechev on 3.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Cocoa
import SwiftSky

class ForecastItem: NSCollectionViewItem {
    @IBOutlet weak var weatherImage: NSImageView!
    @IBOutlet weak var dayLbl: NSTextField!
    @IBOutlet weak var minMaxLbl: NSTextField!
//    var days: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 8
        getForecastData(day: 1 ) {
        
        }
        
    }
    func getForecastData(day: Int, complete: @escaping DownloadComplete)  {
        SwiftSky.secret = API_KEY
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.speed = .meterPerSecond
        SwiftSky.units.pressure = .hectopascal
        SwiftSky.language = .bulgarian
        SwiftSky.hourAmount = .hundredSixtyEight
        SwiftSky.get([DataType.days], at: location) { (result) in
           
            let dateFormater  = DateFormatter()
            dateFormater.locale = Locale(identifier: "bg_BG")
            dateFormater.dateFormat = "eeee"
            let dayForecast = result.response?.days?.points[day].time
            self.dayLbl.stringValue = dateFormater.string(from: dayForecast ?? Date()).capitalized
            self.minMaxLbl.stringValue = "\(result.response?.days?.points[day].temperature?.min?.label ?? "N/A") | \(result.response?.days?.points[day].temperature?.max?.label ?? "N/A")"
            self.weatherImage.image = NSImage(imageLiteralResourceName: "\(result.response?.days?.points[day].icon ?? "clear-day")")
            
        }
        complete()
    }
    
}
