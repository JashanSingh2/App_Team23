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
    
    func rideHistory(At index: Int)-> RideHistory
    
    //private func filterRideHistory(by type: VehicleType) -> [RideHistory]
    

    func rideHistoryOfBus(At index: Int) -> RideHistory
    
    func numberOfRidesInHistory()-> Int
    
    func numberOfBusRidesInHistory()-> Int
    
    
    //for ride suggestions
    func rideSuggestion(At index: Int)-> RidesAvailable
    
    //for myRides
    func numberOfUpcomingRides(for date: String)-> Int
    
    
    func upcomingRides(At index: Int, for date: String)-> RideHistory
    
    func numberOfPreviousRides()-> Int
    
    func previousRides(At index: Int)-> RideHistory
    
    func ride(from source: String,to destination: String, on date: String)-> [(RidesAvailable, Schedule, Schedule)]?
    
    func newRideHistory(with ride: RideHistory)
    
    func numberOfRidesAvailable()-> Int
    
    func availableRide(At index: Int)-> RidesAvailable
    
    func fareOfRide(from source: Schedule, to destination: Schedule, in serviceProvider: ServiceProvider) -> Int
}


class RidesDataController: DataController {
    
    

    

    static var shared = RidesDataController()
    
    init() {
        loadDummyData()
        today = getTodayDate()
        tomorrow = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!)
        later = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date.now)!)
    }
    
    private var allServiceProviders: [ServiceProvider] = []
    
    private var availableRides: [RidesAvailable] = []
    
    private var ridesHistory: [RideHistory] = []
    
    
    
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
            ServiceProvider(name: "Anuj", vehicleNumber: "A1035", rideType: RideType(vehicleModelName: "Force Traveller", vehicleType: .bus, facility: .nonAc), maxSeats: 35, fare: 55, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar", time: "08:00"),
                Schedule(address: "Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ], rating: 3.5
            ),
            ServiceProvider(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar", time: "08:00"),
                Schedule(address: "Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ] , rating: 4.9
            ),
            
            ServiceProvider(name: "Aryan", vehicleNumber: "B1035", rideType: RideType(vehicleModelName: "Suzuki Dzire", vehicleType: .car, facility: .nonAc), maxSeats: 3, fare: 85, route: [
                Schedule(address: "Akshardham", time: "07:40"),
                Schedule(address: "Yamuna Bank", time: "07:50"),
                Schedule(address: "Mayur Vihar 1", time: "08:00"),
                Schedule(address: "Ashok Nagar", time: "08:05"),
                Schedule(address: "Noida Sec-15", time: "08:15"),
                Schedule(address: "Noida Sec-18", time: "08:25"),
                Schedule(address: "Botanical Garden", time: "08:30"),
                Schedule(address: "Noida City Centre", time: "08:40"),
                Schedule(address: "Noida Sec-51", time: "08:45"),
                Schedule(address: "Noida Sec-62", time: "09:10")
                ] , rating: 4.6
            ),
            ServiceProvider(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
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
            ServiceProvider(name: "Jashan", vehicleNumber: "B5911", rideType: RideType(vehicleModelName: "XL6", vehicleType: .car, facility: .ac), maxSeats: 5, fare: 135, route: [
                Schedule(address: "Pari Chowk", time: "08:00"),
                Schedule(address: "Jaypee Hospital", time: "08:35"),
                Schedule(address: "Axis Bank", time: "08:40"),
                Schedule(address: "Amity University", time: "08:50"),
                Schedule(address: "Okhla Bird Sanctuary", time: "09:00"),
                Schedule(address: "Botanical Garden", time: "09:10")
                ] , rating: 3.9
            ),
            ServiceProvider(name: "Vishal", vehicleNumber: "C9099", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 40, fare: 90, route: [
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
            ServiceProvider(name: "Lakshay", vehicleNumber: "B0101", rideType: RideType(vehicleModelName: "Nexon", vehicleType: .car, facility: .ac), maxSeats: 4, fare: 150, route: [
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
            RidesAvailable(date: today, seatsAvailable: 30, serviceProvider: allServiceProviders[0]),
            RidesAvailable(date: today, seatsAvailable: 3, serviceProvider: allServiceProviders[2]),
            RidesAvailable(date: tomorrow, seatsAvailable: 40, serviceProvider: allServiceProviders[3]),
            RidesAvailable(date: tomorrow, seatsAvailable: 4, serviceProvider: allServiceProviders[4]),
            RidesAvailable(date: later, seatsAvailable: 35, serviceProvider: allServiceProviders[5]),
            RidesAvailable(date: later, seatsAvailable: 3, serviceProvider: allServiceProviders[6]),
            RidesAvailable(date: later, seatsAvailable: 33, serviceProvider: allServiceProviders[3])
        ]
        
        ridesHistory = [
            RideHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "2025-01-17", fare: 150, seatNumber: nil),
            RideHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-18", fare: 30, seatNumber: [21]),
            RideHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "2025-01-19", fare: 40, seatNumber: [1]),
            RideHistory(source: Schedule(address: "Knowledge Park-II", time: "8:05 AM"), destination: Schedule(address: "Okhla Bird Sanctuary", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-20", fare: 45, seatNumber: [3]),
            RideHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "2025-01-28", fare: 150, seatNumber: nil),
            RideHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "2025-01-29", fare: 30, seatNumber: [17]),
            RideHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "2025-01-30", fare: 40, seatNumber: [14])
        ]
    }
    
    
    //for ride history
    
    func rideHistoryAddress(At index: Int)-> String{
        return ridesHistory[index].destination.address
    }
    
    func rideHistory(At index: Int)-> RideHistory{
        return ridesHistory[index]
    }
    
    private func filterRideHistory(by type: VehicleType) -> [RideHistory] {
        var filteredRides: [RideHistory] = []
        for ride in ridesHistory {
            if ride.serviceProvider.rideType.vehicleType == type {
                filteredRides.append(ride)
            }
        }
        return filteredRides
    }
    
    
    
    func rideHistoryOfBus(At index: Int) -> RideHistory {
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
    func rideSuggestion(At index: Int)-> RidesAvailable{
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
    
    
    private func upcomingRides(for date: String)-> [RideHistory]{
        var upcomingRides: [RideHistory] = []
        for ride in ridesHistory{
            if ride.date == date{
                upcomingRides.append(ride)
            }
        }
        return upcomingRides
    }
    
    func upcomingRides(At index: Int, for date: String)-> RideHistory{
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
    
    func previousRides(At index: Int)-> RideHistory{
        if ridesHistory[index].date != today && ridesHistory[index].date != tomorrow && ridesHistory[index].date != later {
            return ridesHistory[index]
            }else {
                return previousRides(At: index+1)
            }
            
    }
    
    func ride(of serviceProvider: ServiceProvider)-> RidesAvailable?{
        for ride in availableRides {
            if ride.serviceProvider == serviceProvider{
                return ride
            }
        }
        return nil
    }
    
    func ride(from source: String,to destination: String, on date: String)-> [(RidesAvailable, Schedule, Schedule)]?{
        
        var ridesAvail: [(RidesAvailable, Schedule, Schedule)] = []
        
        var sourceFound: Bool = false
        var sourceAdd: Schedule = Schedule(address: "", time: "")
        var destinationAdd: Schedule
        //var destinationFound: Bool = false
        
        for ride in availableRides{
            for schedule in ride.serviceProvider.route{
                if cosineSimilarity(source, schedule.address) > 0.6 && onTime(date, comparedTo: schedule.time) && !sourceFound{
                    sourceAdd = schedule
                    sourceFound = true
                }
                if cosineSimilarity(destination, schedule.address) > 0.6 && onTime(date, comparedTo: schedule.time) && sourceFound{
                    //destinationFound = true
                    destinationAdd = schedule
                    if sourceFound{
                        ridesAvail.append((ride, sourceAdd, destinationAdd))
                    }
                }
            }
            print(ridesAvail)
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

    
    func newRideHistory(with ride: RideHistory){
        print(ridesHistory.count)
        
        ridesHistory.append(ride)
        print(ridesHistory.count)
    }
    
    func numberOfRidesAvailable() -> Int {
        return availableRides.count
    }
    
    func availableRide(At index: Int) -> RidesAvailable {
        return availableRides[index]
    }
    
    func cancelRide(rideHistory: RideHistory){
        var index: Int = 0
        for ride in ridesHistory{
            if ride.source.address == rideHistory.source.address && ride.destination.address == rideHistory.destination.address && ride.date == rideHistory.date && ride.serviceProvider == rideHistory.serviceProvider{
                ridesHistory.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    func fareOfRide(from source: Schedule, to destination: Schedule, in serviceProvider: ServiceProvider) -> Int {
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
        return Int((stops/serviceProvider.route.count) * serviceProvider.fare)
    }
    
    
    
    
}

