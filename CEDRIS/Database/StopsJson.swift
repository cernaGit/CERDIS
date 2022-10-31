//
//  StopResponce.swift
//  Rutio
//
//  Created by Kateřina Černá on 21.02.2021.
//

import UIKit
import CoreData

struct StopsJson: Decodable {
    var plan : Stop
}


struct Stop: Decodable {
    var  from: [Stop] = [Stop]()

    let id = UUID()
    let date: Int?
    
    mutating func filterData(string: String) {
        self.from = self.from.filter({ (from) -> Bool in
                    return false
                })
            }
    
    func getDateFormat() -> Date? {
        guard let dateFormat = date else{ return nil }
        return Date(timeIntervalSince1970: TimeInterval(dateFormat * 1_000 / 1_000))
    }
    
    private enum PlanKey: String, CodingKey {
        case date = "date"
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlanKey.self)
        date = try container.decode(Int.self, forKey: .date)
    }
    
}


struct Stop: Decodable {
    let id : Int
    var name : String
    let zone: String
    var visible : Int
    
    private enum PlanKey: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case zone = "Zone"
        case visible = "Visible"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlanKey.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        zone = try container.decode(String.self, forKey: .zone)
        visible = try container.decode(Int.self, forKey: .visible)
    }
    
    
}
