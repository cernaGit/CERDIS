//
//  FavouriteTrasManagerDelegate.swift
//  Rutio
//
//  Created by Kateřina Černá on 28.12.2020.
//

import Foundation

protocol FavouriteTrasManagerDelagate {
    func insertTras(name: String, start: String, destination: String, lat1: Double, lat2: Double, long1: Double, long2: Double)
}
