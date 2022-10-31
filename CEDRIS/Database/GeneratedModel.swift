//
//  GeneratedModel.swift
//  Rutio
//
//  Created by Kateřina Černá on 29.04.2021.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let requestParameters: RequestParameters
    let plan: Plan
    let metadata: Metadata
    let debugOutput: DebugOutput
    let elevationMetadata: ElevationMetadata
}
// MARK: - DebugOutput
struct DebugOutput: Codable {
    let precalculationTime, directStreetRouterTime, transitRouterTime, filteringTime: Int
    let renderingTime, totalTime: Int
    let transitRouterTimes: TransitRouterTimes
}
// MARK: - TransitRouterTimes
struct TransitRouterTimes: Codable {
    let tripPatternFilterTime, accessEgressTime, raptorSearchTime, itineraryCreationTime: Int
}
// MARK: - ElevationMetadata
struct ElevationMetadata: Codable {
    let ellipsoidToGeoidDifference: Double
    let geoidElevation: Bool
}
// MARK: - Metadata
struct Metadata: Codable {
    let searchWindowUsed, nextDateTime, prevDateTime: Int
}
// MARK: - Plan
struct Plan: Codable {
    let date: Int
    let from, to: From
    let itineraries: [Itinerary]
}
// MARK: - From
struct From: Codable {
    let name, stopID: String
    let lon, lat: Double
    let stopIndex: Int
    let vertexType: Mode
    let departure, arrival: Int?
    enum CodingKeys: String, CodingKey {
        case name
        case stopID = "stopId"
        case lon, lat, stopIndex, vertexType, departure, arrival
    }
}
enum Mode: String, Codable {
    case transit = "TRANSIT"
}

// MARK: - Itinerary
struct Itinerary: Codable {
    let duration, startTime, endTime, walkTime: Int
    let transitTime, waitingTime: Int
    let walkDistance: Double
    let walkLimitExceeded: Bool
    let elevationLost, elevationGained, transfers: Int
    let legs: [Leg]
    let tooSloped: Bool
}
// MARK: - Leg
struct Leg: Codable {
    let startTime, endTime, departureDelay, arrivalDelay: Int
    let realTime: Bool
    let distance: Double
    let pathway: Bool
    let mode: String
    let transitLeg: Bool
    let route: String
    let agencyName: String?
    let agencyURL: String?
    let agencyTimeZoneOffset: Int
    let routeColor, routeID, routeTextColor, tripBlockID: String?
    let headsign, agencyID, tripID, serviceDate: String?
    let from, to: From
    let intermediateStops: [From]?
    let legGeometry: LegGeometry
    let steps: [Step]
    let routeShortName, routeLongName: String?
    let duration: Int
    let interlineWithPreviousLeg, rentedBike: Bool?
    enum CodingKeys: String, CodingKey {
        case startTime, endTime, departureDelay, arrivalDelay, realTime, distance, pathway, mode, transitLeg, route, agencyName
        case agencyURL = "agencyUrl"
        case agencyTimeZoneOffset, routeColor
        case routeID = "routeId"
        case routeTextColor
        case tripBlockID = "tripBlockId"
        case headsign
        case agencyID = "agencyId"
        case tripID = "tripId"
        case serviceDate, from, to, intermediateStops, legGeometry, steps, routeShortName, routeLongName, duration, interlineWithPreviousLeg, rentedBike
    }
}
// MARK: - LegGeometry
struct LegGeometry: Codable {
    let points: String
    let length: Int
}
// MARK: - Step
struct Step: Codable {
    let distance: Double
    let relativeDirection: RelativeDirection
    let streetName, absoluteDirection: String
    let stayOn, area, bogusName: Bool
    let lon, lat: Double
    let elevation: String
}
enum RelativeDirection: String, Codable {
    case depart = "DEPART"
    case relativeDirectionRIGHT = "RIGHT"
    case slightlyRight = "SLIGHTLY_RIGHT"
}
// MARK: - RequestParameters
struct RequestParameters: Codable {
    let date, wheelchair, walkReluctance, triangleTimeFactor: String
    let fromPlace, maxWalkDistance, triangleSlopeFactor: String
    let mode: Mode
    let arriveBy, min, showIntermediateStops, optimize: String
    let useRequestedDateTimeInMaxHours, toPlace, searchWindow, time: String
    let allowBikeRental: String
}
