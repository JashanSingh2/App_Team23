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
    func rideHistoryAddress(At index: Int) -> String
    func rideHistory(At index: Int) -> RideHistory
    func rideHistoryOfBus(At index: Int) -> RidesHistory
    func numberOfRidesInHistory() -> Int
    func numberOfBusRidesInHistory() -> Int
    func rideSuggestion(At index: Int) -> RideAvailable
    func numberOfUpcomingRides(for date: String) -> Int
    func upcomingRides(At index: Int, for date: String) -> RidesHistory
    func numberOfPreviousRides() -> Int
    func previousRides(At index: Int) -> RidesHistory
    func ride(from source: String, to destination: String, on date: String) -> [(RideAvailable, Schedule, Schedule, Int)]?
    func newRideHistory(with ride: RidesHistory) async throws
    
    //private func filterRideHistory(by type: VehicleType) -> [RideHistory]
    
    func numberOfRidesAvailable() -> Int
    
    func availableRide(At index: Int) -> RideAvailable
    
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
    let source_time: String
    let destination: String
    let destination_time: String
    let service_provider_id: Int
    let date: String
    let fare: Int
    let seat_number: [Int]?
    var serviceProvider: ServiceProviderDB?
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case source_time
        case destination
        case destination_time
        case service_provider_id
        case date
        case fare
        case seat_number
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
    private var ridesHistory: [RideHistory] = []
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
        
        print(loadFilteredBusData(for: "A1035"))
    }
    
    private func fetchAllData() async throws {
        // Fetch rides history
        ridesHistory = try await fetchRidesFromSupabase()
        
        // Fetch service providers
        allServiceProviders = try await fetchServiceProvidersFromSupabase()
        
        // Fetch available rides
        availableRides = try await fetchAvailableRidesFromSupabase()
    }
    
    func fetchRidesFromSupabase() async throws -> [RideHistory] {
        let response: PostgrestResponse<[RideHistory]> = try await supabase.database
            .from("ridehistory")
            .select()
            .execute()
        
        return response.value
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
                route: loadFilteredBusData(for: providerDB.vehicleNumber) ?? [],
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
                route: loadFilteredBusData(for: rideSharingDB.vehicleNumber) ?? [], // You might want to handle route separately
                rating: rideSharingDB.rating
            )
            
            return RideAvailable(
                date: getTodayDate(),
                seatsAvailable: rideSharingDB.maxSeats,
                serviceProvider: serviceProvider
            )
        }
    }
    
    struct BusInfo: Codable {
        let address: String
        let time: String
        let vehicleNumber: String

        // Map JSON keys to Swift properties
        enum CodingKeys: String, CodingKey {
            case address = "Address"
            case time = "Time"
            case vehicleNumber = "VehicleNumber"
        }
    }

    

    func loadFilteredBusData(for vehicleNumber: String) -> [Schedule]? {
        guard let url = Bundle.main.url(forResource: "merged_vehicle_routes", withExtension: "json") else {
            print("🚨 JSON file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            
            let fullBusData = try JSONDecoder().decode([BusInfo].self, from: data)
            
            let filteredBuses: [Schedule] = fullBusData
                .filter { $0.vehicleNumber == vehicleNumber }
                .map { Schedule(address: $0.address, time: $0.time) }

            return filteredBuses.isEmpty ? nil : filteredBuses
        } catch {
            print("❌ Error decoding JSON: \(error)")
            return nil
        }
    }

    
    func getBusDetails(for vehicleNumber: String) {
        if let buses = loadFilteredBusData(for: vehicleNumber) {
            for bus in buses {
                print("✅ Address: \(bus.address), Time: \(bus.time)")
            }
        } else {
            print("❌ No data found for bus number: \(vehicleNumber)")
        }
    }






    
    
    func saveRideToSupabase(_ ride: RideHistory) async throws {
        let response: PostgrestResponse<[RideHistory]> = try await supabase.database
            .from("ridehistory")
            .insert(ride)
            .execute()
        print("📡 Sending data to Supabase...")
    }
    
    // Existing helper functions
    func getTodayDate() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date.now)
    }
    
    // Existing query functions
    func rideHistoryAddress(At index: Int) -> String {
        return ridesHistory[index].destination
    }
    
    func rideHistory(At index: Int) -> RideHistory {
        return ridesHistory[index]
    }
    
    private func filterRideHistory(by type: VehicleType) -> [RideHistory] {
        let group = DispatchGroup()
        var filteredRides: [RideHistory] = []
        
        for ride in ridesHistory {
            group.enter()
            Task {
                if let provider = try? await fetchServiceProvider(id: ride.service_provider_id) {
                    if provider.vehicleType == type.rawValue {
                        filteredRides.append(ride)
                    }
                }
                group.leave()
            }
        }
        
        group.wait()
        return filteredRides
    }
    
    func rideHistoryOfBus(At index: Int) -> RidesHistory {
        let group = DispatchGroup()
        var result: RidesHistory?
        
        group.enter()
        Task {
            let rideHistoryOfBus = filterRideHistory(by: .bus)
            let ride = rideHistoryOfBus[index]
            result = try? await convertToRidesHistory(ride)
            group.leave()
        }
        
        group.wait()
        return result!
    }
    
    func numberOfRidesInHistory() -> Int {
        return ridesHistory.count
    }
    
    func numberOfBusRidesInHistory() -> Int {
        let group = DispatchGroup()
        var busRidesCount = 0
        let localRides = ridesHistory // Create local copy
        
        for ride in localRides {
            group.enter()
            Task {
                if let provider = try? await fetchServiceProvider(id: ride.service_provider_id) {
                    if provider.vehicleType == "bus" {
                        busRidesCount += 1
                    }
                }
                group.leave()
            }
        }
        
        group.wait()
        return min(busRidesCount, 3)
    }
    
    func rideSuggestion(At index: Int) -> RideAvailable {
        return availableRides[index]
    }
    
    func numberOfUpcomingRides(for date: String) -> Int {
        return ridesHistory.filter { $0.date == date }.count
    }
    
    private func upcomingRides(for date: String) -> [RideHistory] {
        return ridesHistory.filter { $0.date == date }
    }
    
    func upcomingRides(At index: Int, for date: String) -> RidesHistory {
        let group = DispatchGroup()
        var result: RidesHistory?
        
        group.enter()
        Task {
            let ride = upcomingRides(for: date)[index]
            result = try? await convertToRidesHistory(ride)
            group.leave()
        }
        
        group.wait()
        return result!
    }
    
    func numberOfPreviousRides() -> Int {
        return ridesHistory.filter { $0.date != today && $0.date != tomorrow && $0.date != later }.count
    }
    
    func previousRides(At index: Int) -> RidesHistory {
        let group = DispatchGroup()
        var result: RidesHistory?
        
        group.enter()
        Task {
            let previousRides = ridesHistory.filter { $0.date != today && $0.date != tomorrow && $0.date != later }
            let ride = previousRides[index]
            result = try? await convertToRidesHistory(ride)
            group.leave()
        }
        
        group.wait()
        return result!
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
    
    func newRideHistory(with ride: RidesHistory) async throws {
        let convertedRide = convertToRideHistory(ride)
        Task {
            do {
                try await saveRideToSupabase(convertedRide)
            } catch {
                print("Error saving ride to Supabase: \(error)")
            }
        }
        ridesHistory = try await fetchRidesFromSupabase()

    }
    
    private func cancelRide(rideHistory: RideHistory) {
        var index: Int = 0
        for ride in ridesHistory {
            if ride.source == rideHistory.source && 
               ride.destination == rideHistory.destination && 
               ride.date == rideHistory.date && 
               ride.service_provider_id == rideHistory.service_provider_id {
                ridesHistory.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    func cancelRide(rideHistory: RidesHistory) async throws{
        let convertedRide = convertToRideHistory(rideHistory)
        cancelRide(rideHistory: convertedRide)
        
        // Also delete from Supabase
        Task {
            do {
                let response: PostgrestResponse<[RideHistory]> = try await supabase.database
                    .from("ridehistory")
                    .delete()
                    .eq("service_provider_id", value: convertedRide.service_provider_id)
                    .eq("date", value: convertedRide.date)
                    .execute()
            } catch {
                print("Error deleting ride from Supabase: \(error)")
            }
        }
        ridesHistory = try await fetchRidesFromSupabase()
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
    
    func fetchServiceProvider(id: Int) async throws -> ServiceProviderDB {
        let response: PostgrestResponse<[ServiceProviderDB]> = try await supabase.database
            .from("ridesharing")
            .select()
            .eq("id", value: id)
            .execute()
        
        guard let provider = response.value.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Provider not found"])
        }
        return provider
    }
    
    private func convertToRidesHistory(_ rideHistory: RideHistory) async throws -> RidesHistory {
        let provider = try await fetchServiceProvider(id: rideHistory.service_provider_id)
        
        return RidesHistory(
            source: Schedule(address: rideHistory.source, time: rideHistory.source_time),
            destination: Schedule(address: rideHistory.destination, time: rideHistory.destination_time),
            serviceProvider: ServiceProviders(
                name: provider.name,
                vehicleNumber: provider.vehicleNumber,
                rideType: RideType(
                    vehicleModelName: provider.vehicleModel,
                    vehicleType: provider.vehicleType == "bus" ? .bus : .car,
                    facility: provider.facility == "ac" ? .ac : .nonAc
                ),
                maxSeats: provider.maxSeats,
                fare: provider.fare,
                route: [],
                rating: provider.rating
            ),
            date: rideHistory.date,
            fare: rideHistory.fare,
            seatNumber: rideHistory.seat_number
        )
    }
    
    func convertToRideHistory(_ ridesHistory: RidesHistory) -> RideHistory {
        let group = DispatchGroup()
        var providerID: Int?
        
        
        
        group.enter()
        Task {
            if let response: PostgrestResponse<[ServiceProviderDB]> = try? await supabase.database
                .from("ridesharing")
                .select()
                .eq("vehicle_number", value: ridesHistory.serviceProvider.vehicleNumber)
                .execute(),
               let provider = response.value.first {
                providerID = provider.id
            }
            group.leave()
        }
        
        group.wait()
        
        return RideHistory(
            id: numberOfRidesInHistory() + 1,  // Generate random ID
            source: ridesHistory.source.address,
            source_time: ridesHistory.source.time,
            destination: ridesHistory.destination.address,
            destination_time: ridesHistory.destination.time,
            service_provider_id: providerID ?? 1000,
            date: ridesHistory.date,
            rating: nil,
            review: nil,
            fare: ridesHistory.fare,
            seat_number: ridesHistory.seatNumber
        )
    }
}

