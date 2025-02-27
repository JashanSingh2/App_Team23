//
//  DataModel.swift
//  App_Team23
//
//  Created by JashanSingh, Aryan Shukla, Firdosh Alam on 13/01/25.
//

import Foundation


enum VehicleType{
    case bus
    case car
}


enum Facility{
    case ac
    case nonAc
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

