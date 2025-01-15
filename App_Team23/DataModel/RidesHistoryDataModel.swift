//
//  RidesHistoryDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

struct RideHistory{
    var source: Schedule
    var destination: Schedule
    var serviceProvider: ServiceProvider
    let date: Date
    var Rating: Double?
    var review: String?
    let rideType: RideType
    let fare: Double
}



