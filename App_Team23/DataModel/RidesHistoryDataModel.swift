//
//  RidesHistoryDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation

//struct RidesHistory{
//    
//    var source: Schedule
//    var destination: Schedule
//    var serviceProvider: ServiceProviders
//    let date: String
//    var Rating: Double?
//    var review: String?
//    let fare: Int
//    let seatNumber: [Int]?
//}

struct RideHistory: Codable {
    let id: UUID  // Primary key
    var source: String
    var sourceTime: String
    var destination: String
    var destinationTime: String
    let serviceProviderID: UUID  // Foreign key to ServiceProvider
    let date: String
    var rating: Double?
    var review: String?
    let fare: Int
    let seatNumber: [Int]?
}

// Add public if needed
public struct RidesHistory: Codable, Equatable {
    public let source: Schedule
    public let destination: Schedule
    public let serviceProvider: ServiceProviders
    public let date: String
    public let fare: Int
    public let seatNumber: [Int]?
    
    public init(source: Schedule, destination: Schedule, serviceProvider: ServiceProviders, date: String, fare: Int, seatNumber: [Int]?) {
        self.source = source
        self.destination = destination
        self.serviceProvider = serviceProvider
        self.date = date
        self.fare = fare
        self.seatNumber = seatNumber
    }
}


