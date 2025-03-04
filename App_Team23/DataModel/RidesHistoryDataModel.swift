//
//  RidesHistoryDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import Foundation


struct RideHistory: Codable {
    let id: Int
    var source: String
    var source_time: String
    var destination: String
    var destination_time: String
    let service_provider_id: Int
    let date: String
    var rating: Double?
    var review: String?
    let fare: Int
    let seat_number: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case source_time
        case destination
        case destination_time
        case service_provider_id
        case date
        case rating
        case review
        case fare
        case seat_number
    }
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


