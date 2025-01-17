//
//  RidesAvailableDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct RidesAvailable{
    var source: Schedule
    var destination: Schedule
    var fare: Double
    var date: String
    var seatsAvailable: Int
    var serviceProvider: ServiceProvider
    var rating: Double
}

