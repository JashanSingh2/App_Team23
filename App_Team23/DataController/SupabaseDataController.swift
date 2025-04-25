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
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    private init() {
        // Initialize Supabase client with your project URL and anon key
        client = SupabaseClient(
            supabaseURL: URL(string: "https://nwjlijnbgvmvcowxyxfu.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53amxpam5iZ3ZtdmNvd3h5eGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNTI1OTgsImV4cCI6MjA1NDkyODU5OH0.Ie59yeseEc8A82gbJ56IVOq17bZOSjEkmzz-8qCPuPo"
        )
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    // MARK: - Helper Functions for JSON
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try jsonDecoder.decode(type, from: jsonData)
    }
    
    private func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        let jsonData = try jsonEncoder.encode(value)
        guard let dict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to encode to dictionary"])
        }
        return dict
    }
    
    // MARK: - Database Models
    
    private struct PassengerDetailsDB: Encodable {
        let id: String
        let name: String
        let pickup_add: String
        let pickup_time: String
        let destination_add: String
        let destination_time: String
        let preferred_vehicle: String
    }
    
    private struct UserDB: Encodable {
        let id: String
        let email_id: String
        let phone_no: String
        let role: String
        let user_details_id: String?
    }
    
    private struct PassengerSignupResponse: Decodable {
        let userId: UUID
        let passengerId: UUID
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case passengerId = "passenger_id"
        }
    }
    
    private struct PassengerDetailsInsert: Encodable {
        let id: String
        let name: String
        let pickup_add: String
        let pickup_time: String
        let destination_add: String
        let destination_time: String
        let preferred_vehicle: String
    }
    
    private struct UserInsert: Encodable {
        let id: String
        let email_id: String
        let phone_no: String
        let role: String
        let user_details_id: String
    }
    
    // MARK: - Authentication Functions
    
    func login(email: String, password: String) async throws -> (user: User2, details: PassengerDetails2?) {
        print("DEBUG: Attempting to login user with email: \(email)")
        do {
            // Step 1: Sign in with additional validation
            let authResponse = try await client.auth.signIn(
                email: email,
                password: password
            )
            
            // Ensure we have a valid user ID
            guard let userId = UUID(uuidString: authResponse.user.id.uuidString) else {
                throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID format"])
            }
            
            print("DEBUG: Successfully authenticated. Fetching user details for ID: \(userId)")
            
            // Step 2: Get user details with explicit error handling
            let response = try await client
                .from("User")
                .select("""
                    *,
                    passenger_details_id (
                        *
                    )
                """)
                .eq("id", value: userId)
                .execute()
            
            print("DEBUG: Raw response data: \(String(describing: response.data))")
            
            // Parse the JSON data
            do {
                guard let userData = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String: Any]],
                      let userInfo = userData.first else {
                    print("DEBUG: Failed to parse user data JSON")
                    throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid user data format"])
                }
                
                print("DEBUG: Parsed user data: \(userInfo)")
                
                // Step 3: Create User2 object
                let user = User2(
                    id: userId,
                    emailId: userInfo["email_id"] as? String ?? "",
                    phoneNo: userInfo["phone_no"] as? String ?? "",
                    role: userInfo["role"] as? String ?? "",
                    userDetailsId: UUID(uuidString: (userInfo["user_details_id"] as? String) ?? "")
                )
                
                print("DEBUG: Created User2 object: \(user)")
                
                // Step 4: Handle passenger details if they exist
                var passengerDetails: PassengerDetails2? = nil
                if let passengerData = userInfo["passenger_details_id"] as? [String: Any] {
                    print("DEBUG: Found passenger details: \(passengerData)")
                    
                    // Convert time strings to Date objects
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    
                    let pickupTime = dateFormatter.date(from: passengerData["pickup_time"] as? String ?? "") ?? Date()
                    let destinationTime = dateFormatter.date(from: passengerData["destination_time"] as? String ?? "") ?? Date()
                    
                    passengerDetails = PassengerDetails2(
                        id: UUID(uuidString: passengerData["id"] as? String ?? "") ?? UUID(),
                        name: passengerData["name"] as? String ?? "",
                        pickupAdd: passengerData["pickup_add"] as? String ?? "",
                        pickupTime: pickupTime,
                        destinationAdd: passengerData["destination_add"] as? String ?? "",
                        destinationTime: destinationTime,
                        preferredVehicle: passengerData["preferred_vehicle"] as? String ?? ""
                    )
                    print("DEBUG: Created PassengerDetails2 object: \(String(describing: passengerDetails))")
                } else {
                    print("DEBUG: No passenger details found in response")
                }
                
                print("DEBUG: Successfully completed login process for user: \(user.id)")
                return (user, passengerDetails)
                
            } catch {
                print("DEBUG: JSON parsing error: \(error)")
                throw NSError(domain: "ParseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user data: \(error.localizedDescription)"])
            }
            
        } catch {
            print("DEBUG: Login error: \(error.localizedDescription)")
            if let postgrestError = error as? PostgrestError {
                print("DEBUG: Postgrest error details:")
                print("DEBUG: Message: \(postgrestError.message ?? "No message")")
                print("DEBUG: Code: \(postgrestError.code ?? "No code")")
                print("DEBUG: Detail: \(postgrestError.detail ?? "No detail")")
                print("DEBUG: Hint: \(postgrestError.hint ?? "No hint")")
            }
            throw error
        }
    }
    
    func signUpPassenger(email: String, password: String, phone: String, passengerDetails: PassengerDetails2) async throws -> User2 {
        print("DEBUG: Attempting to sign up passenger with email: \(email)")
        print("DEBUG: Passenger details ID: \(passengerDetails.id)")
        do {
            // Step 1: Create auth user with validation
            let authResponse = try await client.auth.signUp(
                email: email,
                password: password
            )
            
            // Ensure we have a valid user ID
            guard let userId = UUID(uuidString: authResponse.user.id.uuidString) else {
                throw NSError(domain: "SignUpError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID format"])
            }
            
            print("DEBUG: Auth user created with ID: \(userId)")
            print("DEBUG: Creating database records...")
            
            // Step 2: Create passenger details
            let passengerInsert = PassengerDetailsInsert(
                id: passengerDetails.id.uuidString,
                name: passengerDetails.name,
                pickup_add: passengerDetails.pickupAdd,
                pickup_time: formatTime(passengerDetails.pickupTime),
                destination_add: passengerDetails.destinationAdd,
                destination_time: formatTime(passengerDetails.destinationTime),
                preferred_vehicle: passengerDetails.preferredVehicle
            )
            
            print("DEBUG: Attempting to insert passenger details with ID: \(passengerInsert.id)")
            
            do {
                // First, create the passenger details record
                let passengerResponse = try await client
                    .from("passenger_details_id")
                    .insert(passengerInsert)
                    .select()
                    .single()
                    .execute()
                    .value
                
                print("DEBUG: Successfully created passenger details. Response: \(String(describing: passengerResponse))")
                
                // Verify passenger details exist before creating user
                let verifyPassenger = try await client
                    .from("passenger_details_id")
                    .select()
                    .eq("id", value: passengerDetails.id.uuidString)
                    .single()
                    .execute()
                    .value
                
                print("DEBUG: Verified passenger details exist: \(String(describing: verifyPassenger))")
                
                // Step 3: Create user record with the passenger details ID
                let userInsert = [
                    "id": userId.uuidString,
                    "email_id": email,
                    "phone_no": phone,
                    "role": "passenger",
                    "user_details_id": passengerDetails.id.uuidString
                ]
                
                print("DEBUG: Attempting to insert user record:")
                print("DEBUG: User data: \(userInsert)")
                
                let userResponse = try await client
                    .from("User")
                    .insert(userInsert)
                    .select()
                    .single()
                    .execute()
                    .value
                
                print("DEBUG: Successfully created user record. Response: \(String(describing: userResponse))")
                
                // Create and return the user object
                let user = User2(
                    id: userId,
                    emailId: email,
                    phoneNo: phone,
                    role: "passenger",
                    userDetailsId: passengerDetails.id
                )
                
                print("DEBUG: Successfully completed signup for user: \(userId)")
                return user
                
            } catch {
                print("DEBUG: Error occurred during database operations: \(error)")
                print("DEBUG: Beginning cleanup...")
                
                if let postgrestError = error as? PostgrestError {
                    print("DEBUG: Postgrest error details:")
                    print("DEBUG: Message: \(postgrestError.message ?? "No message")")
                    print("DEBUG: Code: \(postgrestError.code ?? "No code")")
                    print("DEBUG: Detail: \(postgrestError.detail ?? "No detail")")
                    print("DEBUG: Hint: \(postgrestError.hint ?? "No hint")")
                }
                
                // Clean up in reverse order
                try? await client
                    .from("User")
                    .delete()
                    .eq("id", value: userId.uuidString)
                    .execute()
                print("DEBUG: Cleaned up user record")
                
                try? await client
                    .from("passenger_details_id")
                    .delete()
                    .eq("id", value: passengerDetails.id.uuidString)
                    .execute()
                print("DEBUG: Cleaned up passenger details")
                
                try? await client.auth.admin.deleteUser(id: userId.uuidString)
                print("DEBUG: Cleaned up auth user")
                
                throw NSError(domain: "DatabaseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create user records: \(error.localizedDescription)"])
            }
            
        } catch {
            print("DEBUG: Signup error: \(error.localizedDescription)")
            throw error
        }
    }
    
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
        
        // Insert the user directly
        _ = try await client
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
        _ = try await client
            .from("serviceprovider_detils")
            .insert(serviceProvider)
            .execute()
        print("DEBUG: Successfully added vehicle with ID: \(serviceProvider.id)")
    }
    
    func addRoute(route: Route2) async throws {
        print("DEBUG: Adding new route")
        _ = try await client
            .from("routes")
            .insert(route)
            .execute()
        print("DEBUG: Successfully added route with ID: \(route.id)")
    }
    
    func addRideAvailable(ride: RidesAvailable2) async throws {
        print("DEBUG: Adding new available ride for date: \(ride.date)")
        _ = try await client
            .from("rides_available")
            .insert(ride)
            .execute()
        print("DEBUG: Successfully added ride with ID: \(ride.id)")
    }
    
    // MARK: - Passenger Functions
    
    func getAllAvailableRides() async throws -> [RidesAvailable2] {
        print("DEBUG: Fetching all available rides")
        let response = try await client
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
        var query = client
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
        let response = try await client
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
        let response: Void = try await client
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
        _ = try await client
            .from("rides_history")
            .update(["ride_status": status.rawValue])
            .eq("id", value: rideId)
            .execute()
        print("DEBUG: Successfully updated ride status")
    }
    
    // MARK: - Ride Filtering Functions
    
    func getSuggestedRides(source: String, destination: String) async throws -> [(provider: ServiceProviderDetails2, history: RidesHistory2)] {
        print("DEBUG: Fetching suggested rides for source: \(source), destination: \(destination)")
        let response = try await client
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
        let response = try await client
            .from("rides_history")
            .select()
            .eq("passenger_id", value: userId)
            .eq("ride_status", value: RideStatus2.completed.rawValue)
            .order("date", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        guard let ridesData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides"])
        }
        
        return try ridesData.map { try decode(RidesHistory2.self, from: $0) }
    }
    
    func getRidesByDate(userId: UUID, isUpcoming: Bool) async throws -> [RidesHistory2] {
        print("DEBUG: Fetching \(isUpcoming ? "upcoming" : "previous") rides for user: \(userId)")
        let now = Date()
        
        let response = try await client
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
        
        let response: Void = try await client
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
        
        let response: Void = try await client
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
        let response = try await client
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
    
    // MARK: - Additional Functions for UI
    
    func getAvailableSeats(for rideId: UUID) async throws -> Int {
        print("DEBUG: Fetching available seats for ride: \(rideId)")
        let bookedSeats = try await client
            .from("rides_history")
            .select("seat_no")
            .eq("service_provider_id", value: rideId)
            .eq("date", value: Date())
            .execute()
            .value
        
        guard let seatsData = bookedSeats as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode seats"])
        }
        
        // Get service provider details to know max capacity
        let provider = try await client
            .from("serviceprovider_detils")
            .select()
            .eq("id", value: rideId)
            .single()
            .execute()
            .value
        
        guard let providerData = provider as? [String: Any],
              let maxCapacity = Int(providerData["max_capacity"] as? String ?? "0") else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to get max capacity"])
        }
        
        let bookedCount = seatsData.count
        return maxCapacity - bookedCount
    }
    
    func searchRides(source: String, destination: String, date: Date) async throws -> [(ride: RidesAvailable2, provider: ServiceProviderDetails2)] {
        print("DEBUG: Searching rides from \(source) to \(destination) on \(date)")
        
        let response = try await client
            .from("rides_available")
            .select("*, serviceprovider_detils(*)")
            .eq("date", value: date)
            .execute()
            .value
        
        guard let ridesData = response as? [[String: Any]] else {
            throw NSError(domain: "FetchError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to decode rides"])
        }
        
        var availableRides: [(RidesAvailable2, ServiceProviderDetails2)] = []
        
        for rideData in ridesData {
            do {
                let ride = try decode(RidesAvailable2.self, from: rideData)
                guard let providerData = rideData["serviceprovider_detils"] as? [String: Any] else { continue }
                let provider = try decode(ServiceProviderDetails2.self, from: providerData)
                
                // Check if provider's route matches source and destination
                let routeResponse = try await client
                    .from("routes")
                    .select()
                    .eq("id", value: provider.routeId)
                    .single()
                    .execute()
                    .value
                
                guard let routeData = routeResponse as? [String: Any] else { continue }
                let route = try decode(Route2.self, from: routeData)
                
                if route.routeData["source"] == source && route.routeData["destination"] == destination {
                    availableRides.append((ride, provider))
                }
            } catch {
                print("DEBUG: Error processing ride: \(error)")
                continue
            }
        }
        
        print("DEBUG: Found \(availableRides.count) matching rides")
        return availableRides
    }
    
    func bookRide(userId: UUID, rideId: UUID, seatNo: Int?, source: String, destination: String) async throws -> RidesHistory2 {
        print("DEBUG: Booking ride for user: \(userId)")
        
        // Get ride and provider details
        let rideResponse = try await client
            .from("rides_available")
            .select("*, serviceprovider_detils(*)")
            .eq("id", value: rideId)
            .single()
            .execute()
            .value
        
        guard let rideData = rideResponse as? [String: Any],
              let ride = try? JSONDecoder().decode(RidesAvailable2.self, from: JSONSerialization.data(withJSONObject: rideData)),
              let providerData = rideData["serviceprovider_detils"] as? [String: Any],
              let provider = try? JSONDecoder().decode(ServiceProviderDetails2.self, from: JSONSerialization.data(withJSONObject: providerData)) else {
            throw NSError(domain: "BookingError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to get ride details"])
        }
        
        // Create ride history entry
        let rideHistory = RidesHistory2(
            id: UUID(),
            passengerId: userId,
            serviceProviderId: provider.id,
            date: ride.date,
            fare: provider.fare,
            seatNo: seatNo ?? 0,
            source: source,
            destination: destination,
            rideStatus: .booked
        )
        
        _ = try await client
            .from("rides_history")
            .insert(rideHistory)
            .execute()
        
        print("DEBUG: Successfully booked ride")
        return rideHistory
    }
    
    func getTodayDate() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    // MARK: - Helper Functions
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func sanitize(_ string: String) -> String {
        return string.replacingOccurrences(of: "'", with: "''")
    }
}
