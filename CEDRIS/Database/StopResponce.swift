//
//  StopResponce.swift
//  Rutio
//
//  Created by Kateřina Černá on 21.02.2021.
//

import UIKit
import CoreData

struct StopResponse: Decodable {
    var plan : Plan2
}


struct Plan2: Decodable {
    var  from: [From2] = [From2]()

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


struct From2: Decodable {
    let id = UUID()
    var vehicle : Int
    let name: String
    let lastStop : String
    let finalStop : String
    let course: String
    var lon : Double = 0
    var lat : Double = 0
    var bearing : Double = 0
    var ltype : Int = 0
    var delay : Int = 0
    var SPZ : String
    var company : String
    var lineID : Int
    
    private enum PlanKey: String, CodingKey {
        case vehicle = "ID"
        case name = "LineName"
        case lastStop = "LastStop"
        case finalStop = "FinalStop"
        case lat = "Lat"
        case lon = "Lng"
        case course = "Course"
        case bearing = "Bearing"
        case ltype = "LType"
        case delay = "Delay"
        case SPZ = "SPZ"
        case company = "Company"
        case lineID = "LineID"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlanKey.self)
        vehicle = try container.decode(Int.self, forKey: .vehicle)
        name = try container.decode(String.self, forKey: .name)
        lastStop = try container.decode(String.self, forKey: .lastStop)
        finalStop = try container.decode(String.self, forKey: .finalStop)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        bearing = try container.decode(Double.self, forKey: .bearing)
        course = try container.decode(String.self, forKey: .course)
        ltype = try container.decode(Int.self, forKey: .ltype)
        delay = try container.decode(Int.self, forKey: .delay)
        SPZ = try container.decode(String.self, forKey: .SPZ)
        company = try container.decode(String.self, forKey: .company)
        lineID = try container.decode(Int.self, forKey: .lineID)
    }
    
    
}


extension Date {
    func getDateInFormat(format: String) -> String {
        let date = self
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeStyle = .short
                
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
        return formatter.string(from: date)
    }
}
