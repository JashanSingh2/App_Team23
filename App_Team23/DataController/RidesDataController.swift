//
//  RidesDataController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import Foundation
import UIKit



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


class RidesDataController: DataController {
    
    
    func loadJSONFromFile() -> [Route]? {
        guard let url = Bundle.main.url(forResource: "merged_vehicle_routes", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // Optional, if needed
            let routes = try decoder.decode([Route].self, from: data)
            return routes
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    func readCSVFile(fileName: String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = fileContent.components(separatedBy: "\n") // Split by new line
            for row in rows {
                let columns = row.components(separatedBy: ",") // Split by comma
                print(columns) // Each row as an array
            }
        } catch {
            print("Error reading CSV: \(error)")
        }
    }

    // Call the function with the CSV file name (without extension)
    

    func parseCSV(fileName: String) -> [ServiceProvider] {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("CSV file not found")
            return []
        }
        
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = fileContent.components(separatedBy: "\n").dropFirst() // Remove header
            var ServiceProviders: [ServiceProvider] = []
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count == 12 {
                    let serviceProvider = ServiceProvider(name: columns[0], vehicleNumber: columns[1], vehicleModel: columns[2], vehicleType: VehicleType(rawValue: columns[3]) ?? .bus, facility:  Facility(rawValue: columns[4]) ?? .nonAc, maxSeats: Int(columns[5]) ?? 0, fare: Int(columns[6]) ?? 10, rating: Double(columns[7]) ?? 0, source: columns[8], sourceTime: columns[9], destination: columns[10], destinationTime: columns[11])
                    ServiceProviders.append(serviceProvider)
                }
            }
            return ServiceProviders
        } catch {
            print("Error reading CSV: \(error)")
            return []
        }
    }

    // Load and print parsed data
    
    

    
    

    
    
    
    static var shared = RidesDataController()
    
    init() {
        if let filePath = Bundle.main.path(forResource: "cleaned_ride_sharing_data1", ofType: "csv") {
            print("CSV file found at: \(filePath)")
        } else {
            print("CSV file not found in bundle!")
        }

        
        loadDummyData()
        today = getTodayDate()
        tomorrow = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!)
        later = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date.now)!)
        
        if let routes = loadJSONFromFile() {
            for route in routes {
                print("\(route.vehicleNumber) - \(route.address) at \(route.time)")
            }
        } else {
            print("Failed to load routes.")
        }
        readCSVFile(fileName: "cleaned_ride_sharing_data1")
        let serviceProviders = parseCSV(fileName: "cleaned_ride_sharing_data1")
        print(serviceProviders)
        
    }
    
    private var allServiceProviders: [ServiceProviders] = []
    
    private var availableRides: [RideAvailable] = []
    
    private var ridesHistory: [RidesHistory] = []
    
    private var userProfile = UserData(name: "Jashan", email: "sample@gmail.com", source: Schedule(address: "Pari Chowk", time: "08:00"), destination: Schedule(address: "Botanical Garden", time: "09:10"), preferredRideType: .bus)
    
    var dateFormatter = DateFormatter()
    
    func getTodayDate() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date.now)
        return todayDate
    }
    
    
    
    
    var today = ""
    var tomorrow = ""
    var later = ""
    
    
    func loadDummyData() {

        allServiceProviders = [
            ServiceProviders(name: "Anuj", vehicleNumber: "A1035", rideType: RideType(vehicleModelName: "Force Traveller", vehicleType: .bus, facility: .nonAc), maxSeats: 35, fare: 55, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar", time: "08:00"),
                Schedule(address: "New Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ], rating: 3.5
            ),
            ServiceProviders(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar", time: "08:00"),
                Schedule(address: "New Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ] , rating: 4.9
            ),
            
            ServiceProviders(name: "Aryan", vehicleNumber: "B1035", rideType: RideType(vehicleModelName: "Suzuki Dzire", vehicleType: .car, facility: .nonAc), maxSeats: 3, fare: 85, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar 1", time: "08:00"),
                Schedule(address: "New Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ] , rating: 4.6
            ),
            ServiceProviders(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
                Schedule(address: "Pari Chowk", time: "08:00"),
                Schedule(address: "Knowledge Park-II", time: "08:05"),
                Schedule(address: "ABC Business Park", time: "08:15"),
                Schedule(address: "Adobe Sector 132", time: "08:25"),
                Schedule(address: "Jaypee Hospital", time: "08:35"),
                Schedule(address: "Axis Bank", time: "08:40"),
                Schedule(address: "Amity University", time: "08:50"),
                Schedule(address: "Okhla Bird Sanctuary", time: "09:00"),
                Schedule(address: "Botanical Garden", time: "09:10")
                ] , rating: 4.1
            ),
            ServiceProviders(name: "Jashan", vehicleNumber: "B5911", rideType: RideType(vehicleModelName: "XL6", vehicleType: .car, facility: .ac), maxSeats: 5, fare: 135, route: [
                Schedule(address: "Pari Chowk", time: "08:00"),
                Schedule(address: "Jaypee Hospital", time: "08:35"),
                Schedule(address: "Axis Bank", time: "08:40"),
                Schedule(address: "Amity University", time: "08:50"),
                Schedule(address: "Okhla Bird Sanctuary", time: "09:00"),
                Schedule(address: "Botanical Garden", time: "09:10")
                ] , rating: 3.9
            ),
            ServiceProviders(name: "Vishal", vehicleNumber: "C9099", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 40, fare: 90, route: [
                Schedule(address: "Sector 62", time: "07:50"),
                Schedule(address: "Fortis Hospital", time: "08:05"),
                Schedule(address: "Sector 52", time: "08:15"),
                Schedule(address: "Sector 32", time: "08:25"),
                Schedule(address: "Golf Course", time: "08:40"),
                Schedule(address: "Sector 37", time: "08:50"),
                Schedule(address: "Axis House", time: "09:15"),
                Schedule(address: "Pari Chowk", time: "09:30")
                ] , rating: 4.8
            ),
            ServiceProviders(name: "Lakshay", vehicleNumber: "B0101", rideType: RideType(vehicleModelName: "Nexon", vehicleType: .car, facility: .ac), maxSeats: 4, fare: 150, route: [
                Schedule(address: "Sector 62", time: "07:50"),
                Schedule(address: "Fortis Hospital", time: "08:05"),
                Schedule(address: "Sector 52", time: "08:15"),
                Schedule(address: "Sector 32", time: "08:25"),
                Schedule(address: "Golf Course", time: "08:40"),
                Schedule(address: "Sector 37", time: "08:50"),
                Schedule(address: "Axis House", time: "09:15"),
                Schedule(address: "Pari Chowk", time: "09:20")
                ], rating: 4.6
            )
            
            ]
        
        availableRides = [
            RideAvailable(date: today, seatsAvailable: 30, serviceProvider: allServiceProviders[0]),
            RideAvailable(date: today, seatsAvailable: 3, serviceProvider: allServiceProviders[2]),
            RideAvailable(date: tomorrow, seatsAvailable: 40, serviceProvider: allServiceProviders[3]),
            RideAvailable(date: tomorrow, seatsAvailable: 4, serviceProvider: allServiceProviders[4]),
            RideAvailable(date: later, seatsAvailable: 35, serviceProvider: allServiceProviders[5]),
            RideAvailable(date: later, seatsAvailable: 3, serviceProvider: allServiceProviders[6]),
            RideAvailable(date: later, seatsAvailable: 33, serviceProvider: allServiceProviders[3])
        ]
        
        ridesHistory = [
            RidesHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "2025-01-17", fare: 150, seatNumber: nil),
            RidesHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-18", fare: 30, seatNumber: [21]),
            RidesHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "2025-01-19", fare: 40, seatNumber: [1]),
            RidesHistory(source: Schedule(address: "Knowledge Park-II", time: "8:05 AM"), destination: Schedule(address: "Okhla Bird Sanctuary", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-20", fare: 45, seatNumber: [3]),
            RidesHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "2025-01-28", fare: 150, seatNumber: nil),
            RidesHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-29", fare: 30, seatNumber: [17]),
            RidesHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "2025-01-30", fare: 40, seatNumber: [14])
        ]
    }
    
    
    //for ride history
    
    func rideHistoryAddress(At index: Int)-> String{
        return ridesHistory[index].destination.address
    }
    
    func rideHistory(At index: Int)-> RidesHistory{
        return ridesHistory[index]
    }
    
    private func filterRideHistory(by type: VehicleType) -> [RidesHistory] {
        var filteredRides: [RidesHistory] = []
        for ride in ridesHistory {
            if ride.serviceProvider.rideType.vehicleType == type {
                filteredRides.append(ride)
            }
        }
        return filteredRides
    }
    
    
    
    func rideHistoryOfBus(At index: Int) -> RidesHistory {
        let rideHistoryOfBus = filterRideHistory(by: .bus)
        return rideHistoryOfBus[index]
    }
    
    func numberOfRidesInHistory()-> Int{
        return ridesHistory.count
    }
    
    func numberOfBusRidesInHistory()-> Int{
        var count: Int = 0
        for ride in ridesHistory{
            if ride.serviceProvider.rideType.vehicleType == .bus{
                count += 1
            }
        }
        
        if count < 3{
            return count
        }else{
                return 3
            
        }
    }
    

    
    
    //for ride suggestions
    func rideSuggestion(At index: Int)-> RideAvailable{
        return availableRides[index]
        
    }
    
    
    
    //for myRides
    func numberOfUpcomingRides(for date: String)-> Int{
        var count: Int = 0
        for ride in ridesHistory{
            if ride.date == date{
                count += 1
            }
        }
        return count
    }
    
    
    private func upcomingRides(for date: String)-> [RidesHistory]{
        var upcomingRides: [RidesHistory] = []
        for ride in ridesHistory{
            if ride.date == date{
                upcomingRides.append(ride)
            }
        }
        return upcomingRides
    }
    
    func upcomingRides(At index: Int, for date: String)-> RidesHistory{
        print(index)
        let upcomingRides = upcomingRides(for: date)
        return upcomingRides[index]
            
    }
    
    
    func numberOfPreviousRides()-> Int{
        var count: Int = 0
        for ride in ridesHistory{
            if ride.date != today && ride.date != tomorrow && ride.date != later {
                count += 1
            }
        }
        return count
    }
    
    func previousRides(At index: Int)-> RidesHistory{
        if ridesHistory[index].date != today && ridesHistory[index].date != tomorrow && ridesHistory[index].date != later {
            return ridesHistory[index]
            }else {
                return previousRides(At: index+1)
            }
            
    }
    
    func ride(of serviceProvider: ServiceProviders)-> RideAvailable?{
        for ride in availableRides {
            if ride.serviceProvider == serviceProvider{
                return ride
            }
        }
        return nil
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

    func similarityScore(userInput: String, storedString: String) -> Double {
        let distance = levenshtein(userInput.lowercased(), storedString.lowercased())
        let maxLength = max(userInput.count, storedString.count)
        return (1.0 - (Double(distance) / Double(maxLength))) * 100
    }

    func isFuzzyMatch(userInput: String, storedString: String, threshold: Double = 70.0) -> Bool {
        return similarityScore(userInput: userInput, storedString: storedString) >= threshold
    }
    
    
    
    
    
    
    
    
    func ride(from source: String,to destination: String, on date: String)-> [(RideAvailable, Schedule, Schedule, Int)]?{
        
        var ridesAvail: [(RideAvailable, Schedule, Schedule, Int)] = []
        
        var sourceFound: Bool = false
        var sourceAdd: Schedule = Schedule(address: "", time: "")
        var destinationAdd: Schedule = Schedule(address: "", time: "")
        //var destinationFound: Bool = false
        
        for ride in availableRides{
            for schedule in ride.serviceProvider.route{
                if (isFuzzyMatch(userInput: source, storedString: schedule.address) && onTime(date, comparedTo: schedule.time) && !sourceFound){
                    
                    print("\(schedule.address)   \(source)   \(cosineSimilarity(source, schedule.address))")
                    
                    sourceAdd = schedule
                    sourceFound = true
                }
                if isFuzzyMatch(userInput: destination, storedString: schedule.address) && onTime(date, comparedTo: schedule.time) && sourceFound{
                    //destinationFound = true
                    print("\(schedule.address)   \(destination)   \(cosineSimilarity(source, schedule.address))")
                    destinationAdd = schedule
                    if sourceFound{
                        let fare = fareOfRide(from: sourceAdd, to: destinationAdd, in: ride.serviceProvider)
                        ridesAvail.append((ride, sourceAdd, destinationAdd, fare))
                        break
                    }
                }
            }
            for ride in ridesAvail{
                print("\(ride.1)")
            }
            return ridesAvail
        }
        return nil
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
    
    func letterFrequency(_ str: String) -> [Character: Int] {
        var frequency: [Character: Int] = [:]
        for char in str.lowercased() {
            frequency[char, default: 0] += 1
        }
        return frequency
    }

    func cosineSimilarity(_ str1: String, _ str2: String) -> Double {
        let freq1 = letterFrequency(str1)
        let freq2 = letterFrequency(str2)

        let uniqueChars = Set(freq1.keys).union(Set(freq2.keys))

        var dotProduct = 0
        var magnitude1 = 0
        var magnitude2 = 0

        for char in uniqueChars {
            let count1 = freq1[char, default: 0]
            let count2 = freq2[char, default: 0]

            dotProduct += count1 * count2
            magnitude1 += count1 * count1
            magnitude2 += count2 * count2
        }

        let denominator = sqrt(Double(magnitude1)) * sqrt(Double(magnitude2))
        return denominator == 0 ? 0.0 : Double(dotProduct) / denominator
    }

    
    func newRideHistory(with ride: RidesHistory){
        print(ridesHistory.count)
        
        ridesHistory.append(ride)
        print(ridesHistory.count)
    }
    
    func numberOfRidesAvailable() -> Int {
        return availableRides.count
    }
    
    func availableRide(At index: Int) -> RideAvailable {
        return availableRides[index]
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
    
    func fareOfRide(from source: Schedule, to destination: Schedule, in serviceProvider: ServiceProviders) -> Int {
        var stops: Int = 0
        var routeMatch: Bool = false
        for stop in serviceProvider.route{
            if stop == source{
                routeMatch = true
            }
            if routeMatch{
                stops += 1
            }
            if stop == destination{
                routeMatch = false
            }
        }
        if Int((stops/serviceProvider.route.count) * serviceProvider.fare) < 10{
            return 10
        }
        
        return Int((stops/serviceProvider.route.count) * serviceProvider.fare)
    }
    
    func rideSuggestion() -> [(RideAvailable,Schedule,Schedule, Int)]? {
        return ride(from: userProfile.source.address, to: userProfile.destination.address, on: userProfile.source.time)
    }
    
    
}

