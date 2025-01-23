//
//  ServiceProviderDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct ServiceProvider{
    var name: String
    var vehicleNumber: String
    var rideType: RideType
    var maxSeats: Int
    var fare: Int
    var route: [Schedule]
}

