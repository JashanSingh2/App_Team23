//
//  NewDataModel.swift
//  App_Team23
//
//  Created by Batch - 1 on 23/04/25.
//

import Foundation

// MARK: - Enums
enum Facility2: String, Codable {
    case ac = "AC"
    case nonAc = "NONAC"
}

enum VehicleType2: String, Codable {
    case car = "car"
    case bus = "bus"
}

enum RideStatus2: String, Codable {
    case booked = "booked"
    case cancelled = "cancelled"
    case completed = "completed"
}

// MARK: - User Model
struct User2: Codable, Identifiable {
    let id: UUID
    let emailId: String
    let phoneNo: String
    let role: String
    let userDetailsId: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id
        case emailId = "email_id"
        case phoneNo = "phone_no"
        case role
        case userDetailsId = "user_details_id"
    }
}

// MARK: - Passenger Details Model
struct PassengerDetails2: Codable, Identifiable {
    let id: UUID
    let name: String
    let pickupAdd: String
    let pickupTime: Date
    let destinationAdd: String
    let destinationTime: Date
    let preferredVehicle: String
    let workTime: String  // Added missing field
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pickupAdd = "pickup_add"
        case pickupTime = "pickup_time"
        case destinationAdd = "destination_add"
        case destinationTime = "destination_time"
        case preferredVehicle = "preferred_vehicle"
        case workTime = "work_time"
    }
}

// MARK: - Service Provider Details Model
struct ServiceProviderDetails2: Codable, Identifiable {
    let id: UUID
    let name: String
    let vehicleName: String
    let vehicleNum: String
    let maxCapacity: String
    let facility: Facility2
    let routeId: UUID?
    let fare: Float
    let rating: Float?
    let vehicleType: VehicleType2
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case vehicleName = "vehicle_name"
        case vehicleNum = "vehicle_num"
        case maxCapacity = "max_capacity"
        case facility
        case routeId = "route_id"
        case fare
        case rating
        case vehicleType = "vehicle_type"
    }
}

// MARK: - Route Model
struct Route2: Codable, Identifiable {
    let id: UUID
    let routeData: [String: String] // Changed to concrete type for Codable conformance
    
    enum CodingKeys: String, CodingKey {
        case id
        case routeData = "route"
    }
}

// MARK: - Rides Available Model
struct RidesAvailable2: Codable, Identifiable {
    let id: UUID
    let serviceProviderId: UUID
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case serviceProviderId = "service_provider_id"
        case date
    }
}

// MARK: - Rides History Model
struct RidesHistory2: Codable, Identifiable {
    let id: UUID
    let passengerId: UUID
    let serviceProviderId: UUID
    let date: Date
    let fare: Float
    let seatNo: Int
    let source: String
    let destination: String
    let rideStatus: RideStatus2
    
    enum CodingKeys: String, CodingKey {
        case id
        case passengerId = "passenger_id"
        case serviceProviderId = "service_provider_id"
        case date
        case fare
        case seatNo = "seat_no"
        case source
        case destination
        case rideStatus = "ride_status"
    }
}
