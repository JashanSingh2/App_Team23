//
//  ServiceProviderDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct ServiceProviders: Equatable{
    static func == (lhs: ServiceProviders, rhs: ServiceProviders) -> Bool {
        if lhs.name == rhs.name && lhs.vehicleNumber == rhs.vehicleNumber && lhs.maxSeats == rhs.maxSeats && lhs.fare == rhs.fare && lhs.route == rhs.route && lhs.rating == rhs.rating{
            return true
        }else{
            return false
        }
    }
    
    var name: String
    var vehicleNumber: String
    var rideType: RideType
    var maxSeats: Int
    var fare: Int
    var route: [Schedule]
    var rating: Double
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


