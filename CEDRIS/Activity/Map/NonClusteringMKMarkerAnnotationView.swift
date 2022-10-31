//
//  NonClusteringMKMarkerAnnotationView.swift
//  Rutio
//
//  Created by Tomáš Skála on 08.11.2021.
//

import UIKit
import MapKit

class NonClusteringMKMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            displayPriority = MKFeatureDisplayPriority.required
        }
    }
}
