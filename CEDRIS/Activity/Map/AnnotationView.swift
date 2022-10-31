//
//  AnnotationView.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.04.2021.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class AnnotationView: MKMarkerAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".AnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = AnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = AnnotationView.preferredClusteringIdentifier
        }
    }
}
