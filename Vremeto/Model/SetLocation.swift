//
//  SetLocation.swift
//  Vremeto
//
//  Created by Vasil Nechev on 5.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Foundation


class SetLocation {
    
    static var instance = SetLocation()
    
    fileprivate var _longitude: Double!
    fileprivate var _latitude: Double!
    
    var longitude: Double{
        get{return _longitude}
        set{_longitude = newValue}
    }
    
    var latitude: Double{
        get{return _latitude}
        set{_latitude = newValue}
    }
    
}
