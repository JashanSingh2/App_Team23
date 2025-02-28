//
//  DataModel.swift
//  App_Team23
//
//  Created by JashanSingh, Aryan Shukla, Firdosh Alam on 13/01/25.
//

import Foundation


enum VehicleType: String{
    case bus = "bus"
    case car = "car"
}


enum Facility: String{
    case ac = "ac"
    case nonAc = "nonAc"
}

struct RideType{
    let vehicleModelName: String?
    let vehicleType: VehicleType
    var facility: Facility
}

struct Schedule: Equatable{
    
    var address: String
    var time: String
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

struct UserData{
    var name: String
    var email: String
    var source: Schedule
    var destination: Schedule
    var preferredRideType: VehicleType
}




