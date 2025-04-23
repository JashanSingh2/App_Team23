//
//  SupabaseDataController.swift
//  App_Team23
//
//  Created by Batch - 1 on 23/04/25.
//

import Foundation
import Supabase

class SupabaseDataController2 {
    static let shared = SupabaseDataController2()
    private let client: SupabaseClient
    
    private init() {
        // Initialize Supabase client with your project URL and anon key
        client = SupabaseClient(
            supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
            supabaseKey: "YOUR_SUPABASE_ANON_KEY"
        )
    }
    
    // MARK: - Authentication Functions
    
    func signUp(email: String, password: String, phone: String, role: String) async throws -> User2 {
        print("DEBUG: Attempting to sign up user with email: \(email)")
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        let userId = authResponse.user.id
        
        let user = User2(
            id: userId,
            emailId: email,
            phoneNo: phone,
            role: role,
            userDetailsId: nil
        )
        
        _ = try await client.database
            .from("User")
            .insert(user)
            .execute()
        
        print("DEBUG: Successfully signed up user with ID: \(userId)")
        return user
    }
    
    func signOut() async throws {
        print("DEBUG: Attempting to sign out user")
        try await client.auth.signOut()
        print("DEBUG: Successfully signed out user")
    }
    
    // MARK: - Service Provider Functions
    
    func addVehicle(serviceProvider: ServiceProviderDetails2) async throws {
        print("DEBUG: Adding new vehicle - \(serviceProvider.vehicleName)")
        _ = try await client.database
            .from("serviceprovider_detils")
            .insert(serviceProvider)
            .execute()
        print("DEBUG: Successfully added vehicle with ID: \(serviceProvider.id)")
    }
    
    func addRoute(route: Route2) async throws {
        print("DEBUG: Adding new route")
        _ = try await client.database
            .from("routes")
            .insert(route)
            .execute()
        print("DEBUG: Successfully added route with ID: \(route.id)")
    }
    
    func addRideAvailable(ride: RidesAvailable2) async throws {
        print("DEBUG: Adding new available ride for date: \(ride.date)")
        _ = try await client.database
            .from("rides_available")
            .insert(ride)
            .execute()
        print("DEBUG: Successfully added ride with ID: \(ride.id)")
    }
    
    // MARK: - Passenger Functions
    
    func getAllAvailableRides() async throws -> [RidesAvailable2] {
        print("DEBUG: Fetching all available rides")
        let response = try await client.database
            .from("rides_available")
            .select()
            .execute()
            .value
        
        guard let rides = response as? [RidesAvailable2] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides"])
        }
        
        print("DEBUG: Found \(rides.count) available rides")
        return rides
    }
    
    func getRidesHistory(passengerId: UUID, status: RideStatus2? = nil) async throws -> [RidesHistory2] {
        print("DEBUG: Fetching rides history for passenger: \(passengerId)")
        var query = client.database
            .from("rides_history")
            .select()
            .eq("passenger_id", value: passengerId)
        
        if let status = status {
            query = query.eq("ride_status", value: status.rawValue)
        }
        
        let response = try await query.execute().value
        
        guard let rides = response as? [RidesHistory2] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides history"])
        }
        
        print("DEBUG: Found \(rides.count) rides in history")
        return rides
    }
    
    func getServiceProviderRoutes(providerId: UUID) async throws -> [Route2] {
        print("DEBUG: Fetching routes for service provider: \(providerId)")
        let response = try await client.database
            .from("routes")
            .select()
            .execute()
            .value
        
        guard let routes = response as? [Route2] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode routes"])
        }
        
        print("DEBUG: Found \(routes.count) routes for provider")
        return routes
    }
    
    // MARK: - Helper Functions
    
    func getServiceProviderDetails(providerId: UUID) async throws -> ServiceProviderDetails2 {
        print("DEBUG: Fetching service provider details for ID: \(providerId)")
        let response = try await client.database
            .from("serviceprovider_detils")
            .select()
            .eq("id", value: providerId)
            .single()
            .execute()
            .value
        
        guard let provider = response as? ServiceProviderDetails2 else {
            throw NSError(domain: "FetchError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Provider not found or failed to decode"])
        }
        
        print("DEBUG: Successfully fetched provider details")
        return provider
    }
    
    func updateRideStatus(rideId: UUID, status: RideStatus2) async throws {
        print("DEBUG: Updating ride status to \(status) for ride: \(rideId)")
        _ = try await client.database
            .from("rides_history")
            .update(["ride_status": status.rawValue])
            .eq("id", value: rideId)
            .execute()
        print("DEBUG: Successfully updated ride status")
    }
    
    // MARK: - Ride Filtering Functions
    
    func getSuggestedRides(source: String, destination: String) async throws -> [(provider: ServiceProviderDetails2, history: RidesHistory2)] {
        print("DEBUG: Fetching suggested rides for source: \(source), destination: \(destination)")
        let response = try await client.database
            .from("rides_history")
            .select("*, serviceprovider_detils(*)")
            .eq("source", value: source)
            .eq("destination", value: destination)
            .execute()
            .value
        
        guard let ridesData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides"])
        }
        
        let matchingRides = ridesData.compactMap { rideData -> (ServiceProviderDetails2, RidesHistory2)? in
            guard let providerData = rideData["serviceprovider_detils"] as? [String: Any],
                  let provider = try? JSONDecoder().decode(ServiceProviderDetails2.self, from: JSONSerialization.data(withJSONObject: providerData)),
                  let ride = try? JSONDecoder().decode(RidesHistory2.self, from: JSONSerialization.data(withJSONObject: rideData)) else {
                return nil
            }
            return (provider, ride)
        }
        
        print("DEBUG: Found \(matchingRides.count) matching rides")
        return matchingRides
    }
    
    func getRecentRides(userId: UUID, limit: Int = 3) async throws -> [RidesHistory2] {
        print("DEBUG: Fetching recent rides for user: \(userId)")
        let response = try await client.database
            .from("rides_history")
            .select()
            .eq("passenger_id", value: userId)
            .eq("ride_status", value: RideStatus2.completed.rawValue)
            .order("date", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        guard let rides = response as? [RidesHistory2] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides history"])
        }
        
        print("DEBUG: Found \(rides.count) recent rides")
        return rides
    }
    
    func getRidesByDate(userId: UUID, isUpcoming: Bool) async throws -> [RidesHistory2] {
        print("DEBUG: Fetching \(isUpcoming ? "upcoming" : "previous") rides for user: \(userId)")
        let now = Date()
        
        let response = try await client.database
            .from("rides_history")
            .select("*, serviceprovider_detils(*)")
            .eq("passenger_id", value: userId)
            .gte("date", value: isUpcoming ? now : nil)
            .lt("date", value: isUpcoming ? nil : now)
            .order("date", ascending: isUpcoming)
            .execute()
            .value
        
        guard let ridesData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides"])
        }
        
        let rides = ridesData.compactMap { data -> RidesHistory2? in
            try? JSONDecoder().decode(RidesHistory2.self, from: JSONSerialization.data(withJSONObject: data))
        }
        
        print("DEBUG: Found \(rides.count) \(isUpcoming ? "upcoming" : "previous") rides")
        return rides
    }
    
    func getCoPassengers(date: Date, serviceProviderId: UUID) async throws -> [(name: String, details: PassengerDetails2)] {
        print("DEBUG: Fetching co-passengers for date: \(date) and provider: \(serviceProviderId)")
        
        // First check if this is a car service
        let provider = try await getServiceProviderDetails(providerId: serviceProviderId)
        guard provider.vehicleType == .car else {
            throw NSError(domain: "ValidationError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Co-passenger lookup only available for car rides"])
        }
        
        let response = try await client.database
            .from("rides_history")
            .select("passenger_id, User!inner(*, passenger_details_id(*))")
            .eq("service_provider_id", value: serviceProviderId)
            .eq("date", value: date)
            .execute()
            .value
        
        guard let passengersData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode passengers"])
        }
        
        let passengers = passengersData.compactMap { data -> (String, PassengerDetails2)? in
            guard let userData = data["User"] as? [String: Any],
                  let detailsData = userData["passenger_details_id"] as? [String: Any],
                  let details = try? JSONDecoder().decode(PassengerDetails2.self, from: JSONSerialization.data(withJSONObject: detailsData)) else {
                return nil
            }
            return (details.name, details)
        }
        
        print("DEBUG: Found \(passengers.count) co-passengers")
        return passengers
    }
    
    func getBookedSeats(date: Date, serviceProviderId: UUID) async throws -> [Int] {
        print("DEBUG: Fetching booked seats for date: \(date) and provider: \(serviceProviderId)")
        
        // First check if this is a bus service
        let provider = try await getServiceProviderDetails(providerId: serviceProviderId)
        guard provider.vehicleType == .bus else {
            throw NSError(domain: "ValidationError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Seat lookup only available for bus rides"])
        }
        
        let response = try await client.database
            .from("rides_history")
            .select("seat_no")
            .eq("service_provider_id", value: serviceProviderId)
            .eq("date", value: date)
            .filter("seat_no", operator: "not.is", value: "null")
            .execute()
            .value
        
        guard let seatsData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode seats"])
        }
        
        let bookedSeats = seatsData.compactMap { $0["seat_no"] as? Int }
        
        print("DEBUG: Found \(bookedSeats.count) booked seats")
        return bookedSeats
    }
    
    func getLoggedInUserDetails(userId: UUID) async throws -> (user: User2, details: PassengerDetails2?) {
        print("DEBUG: Fetching details for logged in user: \(userId)")
        let response = try await client.database
            .from("User")
            .select("*, passenger_details_id(*)")
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        
        guard let userData = response as? [String: Any] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data"])
        }
        
        guard let user = try? JSONDecoder().decode(User2.self, from: JSONSerialization.data(withJSONObject: userData)) else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])
        }
        
        var passengerDetails: PassengerDetails2? = nil
        if let detailsData = userData["passenger_details_id"] as? [String: Any] {
            passengerDetails = try? JSONDecoder().decode(PassengerDetails2.self, from: JSONSerialization.data(withJSONObject: detailsData))
        }
        
        print("DEBUG: Successfully fetched user details")
        return (user, passengerDetails)
    }
}
