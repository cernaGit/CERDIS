//
//  Responce.swift
//  Rutio
//
//  Created by Kateřina Černá on 23.11.2020.
//

import UIKit
import CoreData


struct IntegerOrString: Decodable {
    var agency: Any

    init(from decoder: Decoder) throws {
        if let int = try? Int(from: decoder) {
            agency = int
            return
        }

        agency = try String(from: decoder)
    }
}

struct Response: Decodable {// or Decodable
  public let agency: [[IntegerOrString]]?
    let name: String
}
