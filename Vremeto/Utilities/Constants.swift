//
//  Constants.swift
//  Vremeto
//
//  Created by Vasil Nechev on 3.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Foundation
import SwiftSky

let API_HOMEPAGE = "https://darksky.net/forecast/43.841,25.971/si24/en"
let API_KEY = "8a1b96fdda7bb2b5bba0038050a2cb06"
let location =  Location(latitude: SetLocation.instance.latitude, longitude: SetLocation.instance.longitude)
typealias DownloadComplete = () -> ()
let NOTIF_DOWNLOAD_COMPLETE = NSNotification.Name("dataDownloaded")
