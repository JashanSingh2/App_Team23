//
//  ServiceProviderDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct ServiceProvider: Equatable{
    static func == (lhs: ServiceProvider, rhs: ServiceProvider) -> Bool {
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

