//
//  RidesDataController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import Foundation
import UIKit
import Supabase
import App_Team23

protocol DataController {
    func rideHistoryAddress(At index: Int)-> String
    
    func rideHistory(At index: Int)-> RidesHistory
    
    //private func filterRideHistory(by type: VehicleType) -> [RideHistory]
    

    func rideHistoryOfBus(At index: Int) -> RidesHistory
    
    func numberOfRidesInHistory()-> Int
    
    func numberOfBusRidesInHistory()-> Int
    
    
    //for ride suggestions
    func rideSuggestion(At index: Int)-> RideAvailable
    
    //for myRides
    func numberOfUpcomingRides(for date: String)-> Int
    
    
    func upcomingRides(At index: Int, for date: String)-> RidesHistory
    
    func numberOfPreviousRides()-> Int
    
    func previousRides(At index: Int)-> RidesHistory
    
    func ride(from source: String,to destination: String, on date: String)-> [(RideAvailable, Schedule, Schedule, Int)]?
    
    func newRideHistory(with ride: RidesHistory)
    
    func numberOfRidesAvailable()-> Int
    
    func availableRide(At index: Int)-> RideAvailable
    
    func fareOfRide(from source: Schedule, to destination: Schedule, in serviceProvider: ServiceProviders) -> Int
}

// First, let's create a struct to match the RideSharing table
struct RideSharingDB: Codable {
    let id: Int
    let name: String
    let vehicleNumber: String
    let maxSeats: Int
    let fare: Int
    let rating: Double
    let vehicleModel: String
    let vehicleType: String
    let facility: String
    let source: String
    let sourceTime: String
    let destination: String
    let destinationTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case vehicleNumber = "vehicle_number"
        case maxSeats = "max_seats"
        case fare
        case rating
        case vehicleModel = "vehicle_model"
        case vehicleType = "vehicle_type"
        case facility
        case source
        case sourceTime = "source_time"
        case destination
        case destinationTime = "destination_time"
    }
}

// Create a struct for RideHistory table
struct RideHistoryDB: Codable {
    let id: Int
    let source: String
    let sourceTime: String
    let destination: String
    let destinationTime: String
    let serviceProviderId: Int
    let date: String
    let fare: Int
    let seatNumber: [Int]?
    var serviceProvider: ServiceProviderDB?
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case sourceTime = "source_time"
        case destination
        case destinationTime = "destination_time"
        case serviceProviderId = "service_provider_id"
        case date
        case fare
        case seatNumber = "seat_number"
        case serviceProvider = "ridesharing"
    }
}

struct ServiceProviderDB: Codable {
    let id: Int
    let name: String
    let vehicleNumber: String
    let maxSeats: Int
    let fare: Int
    let rating: Double
    let vehicleModel: String
    let vehicleType: String
    let facility: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case vehicleNumber = "vehicle_number"
        case maxSeats = "max_seats"
        case fare
        case rating
        case vehicleModel = "vehicle_model"
        case vehicleType = "vehicle_type"
        case facility
    }
}

class RidesDataController: DataController {
    
    private let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://nwjlijnbgvmvcowxyxfu.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53amxpam5iZ3ZtdmNvd3h5eGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNTI1OTgsImV4cCI6MjA1NDkyODU5OH0.Ie59yeseEc8A82gbJ56IVOq17bZOSjEkmzz-8qCPuPo"
    )
    
    static var shared = RidesDataController()
    
    private var allServiceProviders: [ServiceProviders] = []
    private var availableRides: [RideAvailable] = []
    private var ridesHistory: [RidesHistory] = []
    private var userProfile = UserData(name: "Jashan", email: "sample@gmail.com", source: Schedule(address: "Pari Chowk", time: "08:00"), destination: Schedule(address: "Botanical Garden", time: "09:10"), preferredRideType: .bus)
    
    var dateFormatter = DateFormatter()
    var today = ""
    var tomorrow = ""
    var later = ""
    
    init() {
        today = getTodayDate()
        tomorrow = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!)
        later = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date.now)!)
        
        Task {
            do {
                try await fetchAllData()
            } catch {
                print("Error fetching data from Supabase: \(error)")
            }
        }
    }
    
    private func fetchAllData() async throws {
        // Fetch rides history
        ridesHistory = try await fetchRidesFromSupabase()
        
        // Fetch service providers
        allServiceProviders = try await fetchServiceProvidersFromSupabase()
        
        // Fetch available rides
        availableRides = try await fetchAvailableRidesFromSupabase()
    }
    
    func fetchRidesFromSupabase() async throws -> [RidesHistory] {
        let response: PostgrestResponse<[RideHistoryDB]> = try await supabase.database
            .from("ridehistory")
            .select("""
                *,
                ridesharing (
                    id,
                    name,
                    vehicle_number,
                    max_seats,
                    fare,
                    rating,
                    vehicle_model,
                    vehicle_type,
                    facility
                )
            """)
            .execute()
        
        return try response.value.compactMap { rideHistoryDB in
            guard let rideSharing = rideHistoryDB.serviceProvider else { return nil }
            
            return RidesHistory(
                source: Schedule(address: rideHistoryDB.source, time: rideHistoryDB.sourceTime),
                destination: Schedule(address: rideHistoryDB.destination, time: rideHistoryDB.destinationTime),
                serviceProvider: ServiceProviders(
                    name: rideSharing.name,
                    vehicleNumber: rideSharing.vehicleNumber,
                    rideType: RideType(
                        vehicleModelName: rideSharing.vehicleModel,
                        vehicleType: rideSharing.vehicleType == "bus" ? .bus : .car,
                        facility: rideSharing.facility == "ac" ? .ac : .nonAc
                    ),
                    maxSeats: rideSharing.maxSeats,
                    fare: rideSharing.fare,
                    route: [],
                    rating: rideSharing.rating
                ),
                date: rideHistoryDB.date,
                fare: rideHistoryDB.fare,
                seatNumber: rideHistoryDB.seatNumber
            )
        }
    }
    
    func fetchServiceProvidersFromSupabase() async throws -> [ServiceProviders] {
        let response: PostgrestResponse<[ServiceProviderDB]> = try await supabase.database
            .from("ridesharing")
            .select()
            .execute()
        
        return response.value.map { providerDB in
            ServiceProviders(
                name: providerDB.name,
                vehicleNumber: providerDB.vehicleNumber,
                rideType: RideType(
                    vehicleModelName: providerDB.vehicleModel,
                    vehicleType: providerDB.vehicleType == "bus" ? .bus : .car,
                    facility: providerDB.facility == "ac" ? .ac : .nonAc
                ),
                maxSeats: providerDB.maxSeats,
                fare: providerDB.fare,
                route: [],
                rating: providerDB.rating
            )
        }
    }
    
    func fetchAvailableRidesFromSupabase() async throws -> [RideAvailable] {
        let response: PostgrestResponse<[RideSharingDB]> = try await supabase.database
            .from("ridesharing")
            .select()
            .execute()
        
        // Convert RideSharingDB to RideAvailable
        return response.value.map { rideSharingDB in
            let serviceProvider = ServiceProviders(
                name: rideSharingDB.name,
                vehicleNumber: rideSharingDB.vehicleNumber,
                rideType: RideType(
                    vehicleModelName: rideSharingDB.vehicleModel,
                    vehicleType: rideSharingDB.vehicleType == "bus" ? .bus : .car,
                    facility: rideSharingDB.facility == "ac" ? .ac : .nonAc
                ),
                maxSeats: rideSharingDB.maxSeats,
                fare: rideSharingDB.fare,
                route: [], // You might want to handle route separately
                rating: rideSharingDB.rating
            )
            
            return RideAvailable(
                date: getTodayDate(),
                seatsAvailable: rideSharingDB.maxSeats,
                serviceProvider: serviceProvider
            )
        }
    }
    
    func saveRideToSupabase(_ ride: RidesHistory) async throws {
        // First, find or create the service provider
        let serviceProviderId = try await findOrCreateServiceProvider(ride.serviceProvider)
        
        // Create the ride history record
        let rideHistoryData = RideHistoryDB(
            id: 0,
            source: ride.source.address,
            sourceTime: ride.source.time,
            destination: ride.destination.address,
            destinationTime: ride.destination.time,
            serviceProviderId: serviceProviderId,
            date: ride.date,
            fare: ride.fare,
            seatNumber: ride.seatNumber
        )
        
        try await supabase.database
            .from("RideHistory")
            .insert(rideHistoryData)
            .execute()
        
        ridesHistory.append(ride)
    }
    
    private func findOrCreateServiceProvider(_ provider: ServiceProviders) async throws -> Int {
        let response: PostgrestResponse<[RideSharingDB]> = try await supabase.database
            .from("RideSharing")
            .select()
            .eq("vehicle_number", value: provider.vehicleNumber)
            .execute()
        
        if let existingProvider = response.value.first {
            return existingProvider.id
        }
        
        // Create new provider
        let newProvider = RideSharingDB(
            id: 0,
            name: provider.name,
            vehicleNumber: provider.vehicleNumber,
            maxSeats: provider.maxSeats,
            fare: provider.fare,
            rating: provider.rating,
            vehicleModel: provider.rideType.vehicleModelName,
            vehicleType: provider.rideType.vehicleType == .bus ? "bus" : "car",
            facility: provider.rideType.facility == .ac ? "ac" : "nonAc",
            source: "",
            sourceTime: "",
            destination: "",
            destinationTime: ""
        )
        
        let insertResponse: PostgrestResponse<[RideSharingDB]> = try await supabase.database
            .from("RideSharing")
            .insert(newProvider)
            .single()
            .execute()
        
        return insertResponse.value[0].id
    }
    
    // Existing helper functions
    func getTodayDate() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date.now)
    }
    
    // Existing query functions
    func rideHistoryAddress(At index: Int) -> String {
        return ridesHistory[index].destination.address
    }
    
    func rideHistory(At index: Int) -> RidesHistory {
        return ridesHistory[index]
    }
    
    private func filterRideHistory(by type: VehicleType) -> [RidesHistory] {
        return ridesHistory.filter { $0.serviceProvider.rideType.vehicleType == type }
    }
    
    func rideHistoryOfBus(At index: Int) -> RidesHistory {
        let rideHistoryOfBus = filterRideHistory(by: .bus)
        return rideHistoryOfBus[index]
    }
    
    func numberOfRidesInHistory() -> Int {
        return ridesHistory.count
    }
    
    func numberOfBusRidesInHistory() -> Int {
        let count = ridesHistory.filter { $0.serviceProvider.rideType.vehicleType == .bus }.count
        return min(count, 3)
    }
    
    func rideSuggestion(At index: Int) -> RideAvailable {
        return availableRides[index]
    }
    
    func numberOfUpcomingRides(for date: String) -> Int {
        return ridesHistory.filter { $0.date == date }.count
    }
    
    private func upcomingRides(for date: String) -> [RidesHistory] {
        return ridesHistory.filter { $0.date == date }
    }
    
    func upcomingRides(At index: Int, for date: String) -> RidesHistory {
        return upcomingRides(for: date)[index]
    }
    
    func numberOfPreviousRides() -> Int {
        return ridesHistory.filter { $0.date != today && $0.date != tomorrow && $0.date != later }.count
    }
    
    func previousRides(At index: Int) -> RidesHistory {
        let previousRides = ridesHistory.filter { $0.date != today && $0.date != tomorrow && $0.date != later }
        return previousRides[index]
    }
    
    func ride(from source: String, to destination: String, on date: String) -> [(RideAvailable, Schedule, Schedule, Int)]? {
        var ridesAvail: [(RideAvailable, Schedule, Schedule, Int)] = []
        
        for ride in availableRides {
            if let (sourceSchedule, destSchedule) = findMatchingRoute(in: ride.serviceProvider.route,
                                                                     source: source,
                                                                     destination: destination,
                                                                     date: date) {
                let fare = fareOfRide(from: sourceSchedule, to: destSchedule, in: ride.serviceProvider)
                ridesAvail.append((ride, sourceSchedule, destSchedule, fare))
            }
        }
        
        return ridesAvail.isEmpty ? nil : ridesAvail
    }
    
    private func findMatchingRoute(in route: [Schedule], source: String, destination: String, date: String) -> (Schedule, Schedule)? {
        var sourceFound = false
        var sourceSchedule: Schedule?
        
        for schedule in route {
            if !sourceFound && isFuzzyMatch(userInput: source, storedString: schedule.address) && onTime(date, comparedTo: schedule.time) {
                sourceSchedule = schedule
                sourceFound = true
            } else if sourceFound && isFuzzyMatch(userInput: destination, storedString: schedule.address) && onTime(date, comparedTo: schedule.time) {
                return (sourceSchedule!, schedule)
            }
        }
        
        return nil
    }
    
    func numberOfRidesAvailable() -> Int {
        return availableRides.count
    }
    
    func availableRide(At index: Int) -> RideAvailable {
        return availableRides[index]
    }
    
    // Keep existing utility functions
    func isFuzzyMatch(userInput: String, storedString: String, threshold: Double = 70.0) -> Bool {
        return similarityScore(userInput: userInput, storedString: storedString) >= threshold
    }
    
    func similarityScore(userInput: String, storedString: String) -> Double {
        let distance = levenshtein(userInput.lowercased(), storedString.lowercased())
        let maxLength = max(userInput.count, storedString.count)
        return (1.0 - (Double(distance) / Double(maxLength))) * 100
    }
    
    func levenshtein(_ lhs: String, _ rhs: String) -> Int {
        let lhsCount = lhs.count
        let rhsCount = rhs.count
        
        guard lhsCount != 0 else { return rhsCount }
        guard rhsCount != 0 else { return lhsCount }
        
        var matrix = Array(repeating: Array(repeating: 0, count: rhsCount + 1), count: lhsCount + 1)

        for i in 0...lhsCount { matrix[i][0] = i }
        for j in 0...rhsCount { matrix[0][j] = j }

        let lhsArray = Array(lhs)
        let rhsArray = Array(rhs)

        for i in 1...lhsCount {
            for j in 1...rhsCount {
                let cost = lhsArray[i - 1] == rhsArray[j - 1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i - 1][j] + 1,  // Deletion
                    matrix[i][j - 1] + 1,  // Insertion
                    matrix[i - 1][j - 1] + cost // Substitution
                )
            }
        }
        return matrix[lhsCount][rhsCount]
    }
    
    func onTime(_ time1: String, comparedTo time2: String) -> Bool {
        let minutes: Int = 15
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
        
        // Convert time strings to Date objects
        guard let date1 = formatter.date(from: time1),
              let date2 = formatter.date(from: time2) else {
            print("Invalid time format")
            return false
        }

        // Calculate the allowed time range (15 minutes before and after)
        let calendar = Calendar.current
        let lowerBound = calendar.date(byAdding: .minute, value: -minutes, to: date2)!
        let upperBound = calendar.date(byAdding: .minute, value: minutes, to: date2)!

        // Check if date1 is within the time range
        return (lowerBound...upperBound).contains(date1)
    }
    
    func fareOfRide(from source: Schedule, to destination: Schedule, in serviceProvider: ServiceProviders) -> Int {
        var stops = 0
        var routeMatch = false
        
        for stop in serviceProvider.route {
            if stop == source {
                routeMatch = true
            }
            if routeMatch {
                stops += 1
            }
            if stop == destination {
                routeMatch = false
            }
        }
        
        let calculatedFare = Int((Double(stops) / Double(serviceProvider.route.count)) * Double(serviceProvider.fare))
        return max(calculatedFare, 10)
    }
    
    func newRideHistory(with ride: RidesHistory) {
        Task {
            do {
                try await saveRideToSupabase(ride)
            } catch {
                print("Error saving ride to Supabase: \(error)")
            }
        }
    }
    
    func cancelRide(rideHistory: RidesHistory){
        var index: Int = 0
        for ride in ridesHistory{
            if ride.source.address == rideHistory.source.address && ride.destination.address == rideHistory.destination.address && ride.date == rideHistory.date && ride.serviceProvider == rideHistory.serviceProvider{
                ridesHistory.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    func rideSuggestion() -> [(RideAvailable,Schedule,Schedule, Int)]? {
        return ride(from: userProfile.source.address, to: userProfile.destination.address, on: userProfile.source.time)
    }
    
    func ensureDataLoaded() async {
        if availableRides.isEmpty {
            do {
                try await fetchAllData()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
}

