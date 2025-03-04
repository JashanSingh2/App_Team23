//
//  ServiceProviderDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

public enum VehicleType: String, Codable {
    case bus
    case car
}

public enum Facility: String, Codable {
    case ac
    case nonAc
}

public struct ServiceProviders: Codable, Equatable {
    public let name: String
    public let vehicleNumber: String
    public let rideType: RideType
    public let maxSeats: Int
    public let fare: Int
    public let route: [Schedule]
    public let rating: Double
    
    public init(name: String, vehicleNumber: String, rideType: RideType, maxSeats: Int, fare: Int, route: [Schedule], rating: Double) {
        self.name = name
        self.vehicleNumber = vehicleNumber
        self.rideType = rideType
        self.maxSeats = maxSeats
        self.fare = fare
        self.route = route
        self.rating = rating
    }
    
    public static func == (lhs: ServiceProviders, rhs: ServiceProviders) -> Bool {
        return lhs.vehicleNumber == rhs.vehicleNumber
    }
}

public struct RideType: Codable, Equatable {
    public let vehicleModelName: String
    public let vehicleType: VehicleType
    public let facility: Facility
    
    public init(vehicleModelName: String, vehicleType: VehicleType, facility: Facility) {
        self.vehicleModelName = vehicleModelName
        self.vehicleType = vehicleType
        self.facility = facility
    }
    
    public static func == (lhs: RideType, rhs: RideType) -> Bool {
        return lhs.vehicleModelName == rhs.vehicleModelName &&
               lhs.vehicleType == rhs.vehicleType &&
               lhs.facility == rhs.facility
    }
}

struct ServiceProvider{
    var name: String
    var vehicleNumber: String
    var vehicleModel: String
    var vehicleType: VehicleType
    var facility: Facility
    var maxSeats: Int
    var fare: Int
    var rating: Double
    var source: String
    var sourceTime: String
    var destination: String
    var destinationTime: String
}


