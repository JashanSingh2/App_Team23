//
//  DataModel.swift
//  App_Team23
//
//  Created by JashanSingh, Aryan Shukla, Firdosh Alam on 13/01/25.
//

import Foundation



struct User: Codable {
    let id: UUID
    let email: String
    let preferred_vehicle: String
    let work_time: String
}


//struct RideType{
//    let vehicleModelName: String?
//    let vehicleType: VehicleType
//    var facility: Facility
//}

public struct Schedule: Codable, Equatable {
    public let address: String
    public let time: String
    
    public init(address: String, time: String) {
        self.address = address
        self.time = time
    }
    
    public static func == (lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.address == rhs.address && lhs.time == rhs.time
    }
}

struct Route: Codable {
    let address: String
    let time: String
    let vehicleNumber: String

    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case time = "Time"
        case vehicleNumber = "VehicleNumber"
    }
}


struct DateAndTime{
    var date: String
    var time: String
}

struct RouteStop {
    var stopName: String
    var stopTime: String
}


struct RideSearch{
    var source: String
    var destination: String
    var numberOfSeats: Int
    var date: Date
}

struct UserData {
    var name: String
    var email: String
    var source: Schedule
    var destination: Schedule
    var preferredRideType: App_Team23.VehicleType
}




