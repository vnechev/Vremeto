//
//  HourlyVC.swift
//  Vremeto
//
//  Created by Vasil Nechev on 24.10.17 г..
//  Copyright © 2017 г. Vasil Nechev. All rights reserved.
//

import Cocoa

class HourlyVC: NSViewController {
    @IBOutlet weak var hourlyColectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.cornerRadius = 5
       
    }
    
}


extension HourlyVC: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let forecastItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HourlyColectionViewItem"), for: indexPath)
        
        guard let forecastCell = forecastItem as? HourlyColectionViewItem else {
            return forecastItem
        }
        
        forecastCell.getForecastData(hour: indexPath.section) {}
        
        return forecastCell
    }
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 12
        
    }
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 580, height: 50)
    }
    
    
}
