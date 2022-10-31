//
//  ClusterAnnotationView.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.04.2021.
//
import UIKit
import MapKit
import CoreData
import CoreLocation

class ClusterAnnotationView: MKAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".ClusterAnnotationView"

        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            clusteringIdentifier = ClusterAnnotationView.preferredClusteringIdentifier
            collisionMode = .circle
            updateImage()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var annotation: MKAnnotation? {
            didSet {
                clusteringIdentifier = ClusterAnnotationView.preferredClusteringIdentifier
                updateImage()
            }
        }

        private func updateImage() {
            if let clusterAnnotation = annotation as? MKClusterAnnotation {
                self.image = image(count: clusterAnnotation.memberAnnotations.count)
            } else {
                self.image = image(count: 1)
            }
        }

        func image(count: Int) -> UIImage {
            let bounds = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))

            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { _ in
                // Fill full circle with tricycle color
                //AppTheme.blueColor.setFill()
                UIBezierPath(ovalIn: bounds).fill()

                // Fill inner circle with white color
                UIColor.white.setFill()
                UIBezierPath(ovalIn: bounds.insetBy(dx: 8, dy: 8)).fill()

                // Finally draw count text vertically and horizontally centered
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ]

                let text = "\(count)"
                let size = text.size(withAttributes: attributes)
                let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
                let rect = CGRect(origin: origin, size: size)
                text.draw(in: rect, withAttributes: attributes)
            }
        }
    }
