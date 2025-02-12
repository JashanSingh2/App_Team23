//
//  RidesDataController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import Foundation
import UIKit



class RidesDataController {
    


//    private init() {
//        loadDummyData()
//        
//    }
//  
    
    //static var shared = RidesDataController()
 static var shared = RidesDataController()
//    static let shared: RidesDataController = {
//        let instance = RidesDataController()
//        return instance
//    }()
    
        private init() {
            loadDummyData()
    
        }
    
    private var allServiceProviders: [ServiceProvider] = []
    
    private var availableRides: [RidesAvailable] = []
    
    private var ridesHistory: [RideHistory] = []
    
    var today = "28/01/2025"
    var tomorrow = "29/01/2025"
    var later = "30/01/2025"
    
    
    func loadDummyData() {
//        let myRoute : [,
//      [Schedule(address: "Akshardham", time: "7:40AM"),
//          Schedule(address: "Yamuna Bank", time: "7:50Am"),
//          Schedule(address: "Mayur Vihar 1", time: "8:00AM"),
//          Schedule(address: "Ashok Nagar", time: "8:05AM"),
//          Schedule(address: "Noida Sec-15", time: "8:15AM"),
//          Schedule(address: "Noida Sec-18", time: "8:25AM"),
//          Schedule(address: "Botanical Garden", time: "8:30AM"),
//          Schedule(address: "Noida City Centre", time: "8:40AM"),
//          Schedule(address: "Noida Sec-51", time: "8:45AM"),
//          Schedule(address: "Noida Sec-62", time: "9:10AM")
//      ],
//        ]
        allServiceProviders = [
            ServiceProvider(name: "Anuj", vehicleNumber: "A1035", rideType: RideType(vehicleModelName: "Force Traveller", vehicleType: .bus, facility: .nonAc), maxSeats: 35, fare: 55, route: [
                Schedule(address: "Akshardham", time: "7:40AM"),
                Schedule(address: "Yamuna Bank", time: "7:50Am"),
                Schedule(address: "Mayur Vihar", time: "8:00AM"),
                Schedule(address: "Ashok Nagar", time: "8:05AM"),
                Schedule(address: "Noida Sec-15", time: "8:15AM"),
                Schedule(address: "Noida Sec-18", time: "8:25AM"),
                Schedule(address: "Botanical Garden", time: "8:30AM"),
                Schedule(address: "Noida City Centre", time: "8:40AM"),
                Schedule(address: "Noida Sec-51", time: "8:45AM"),
                Schedule(address: "Noida Sec-62", time: "9:10AM")
            ]),
            ServiceProvider(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
                Schedule(address: "Akshardham", time: "7:40AM"),
                Schedule(address: "Yamuna Bank", time: "7:50Am"),
                Schedule(address: "Mayur Vihar", time: "8:00AM"),
                Schedule(address: "Ashok Nagar", time: "8:05AM"),
                Schedule(address: "Noida Sec-15", time: "8:15AM"),
                Schedule(address: "Noida Sec-18", time: "8:25AM"),
                Schedule(address: "Botanical Garden", time: "8:30AM"),
                Schedule(address: "Noida City Centre", time: "8:40AM"),
                Schedule(address: "Noida Sec-51", time: "8:45AM"),
                Schedule(address: "Noida Sec-62", time: "9:10AM")
            ]),
            
            ServiceProvider(name: "Aryan", vehicleNumber: "B1035", rideType: RideType(vehicleModelName: "Suzuki Dzire", vehicleType: .car, facility: .nonAc), maxSeats: 3, fare: 85, route: [
                Schedule(address: "Akshardham", time: "7:40AM"),
                Schedule(address: "Yamuna Bank", time: "7:50Am"),
                Schedule(address: "Mayur Vihar 1", time: "8:00AM"),
                Schedule(address: "Ashok Nagar", time: "8:05AM"),
                Schedule(address: "Noida Sec-15", time: "8:15AM"),
                Schedule(address: "Noida Sec-18", time: "8:25AM"),
                Schedule(address: "Botanical Garden", time: "8:30AM"),
                Schedule(address: "Noida City Centre", time: "8:40AM"),
                Schedule(address: "Noida Sec-51", time: "8:45AM"),
                Schedule(address: "Noida Sec-62", time: "9:10AM")
            ]),
            ServiceProvider(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
                Schedule(address: "Pari Chowk", time: "8:00AM"),
                Schedule(address: "Knowledge Park-II", time: "8:05 AM"),
                Schedule(address: "ABC Business Park", time: "8:15 AM"),
                Schedule(address: "Adobe Sector 132", time: "8:25 AM"),
                Schedule(address: "Jaypee Hospital", time: "8:35 AM"),
                Schedule(address: "Axis Bank", time: "8:40 AM"),
                Schedule(address: "Amity University", time: "8:50 AM"),
                Schedule(address: "Okhla Bird Sanctuary", time: "9:00 AM"),
                Schedule(address: "Botanical Garden", time: "9:10 AM")
            ]),
            ServiceProvider(name: "Jashan", vehicleNumber: "B5911", rideType: RideType(vehicleModelName: "XL6", vehicleType: .car, facility: .ac), maxSeats: 5, fare: 135, route: [
                Schedule(address: "Pari Chowk", time: "8:00AM"),
                Schedule(address: "Jaypee Hospital", time: "8:35 AM"),
                Schedule(address: "Axis Bank", time: "8:40 AM"),
                Schedule(address: "Amity University", time: "8:50 AM"),
                Schedule(address: "Okhla Bird Sanctuary", time: "9:00 AM"),
                Schedule(address: "Botanical Garden", time: "9:10 AM")
            ]),
            ServiceProvider(name: "Vishal", vehicleNumber: "C9099", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 40, fare: 90, route: [
                Schedule(address: "Sector 62", time: "7:50 AM"),
                Schedule(address: "Fortis Hospital", time: "8:05 AM"),
                Schedule(address: "Sector 52", time: "8:15 AM"),
                Schedule(address: "Sector 32", time: "8:25 AM"),
                Schedule(address: "Golf Course", time: "8:40 AM"),
                Schedule(address: "Sector 37", time: "8:50 AM"),
                Schedule(address: "Axis House", time: "9:15 AM"),
                Schedule(address: "Pari Chowk", time: "9:30 AM")
            ]),
            ServiceProvider(name: "Lakshay", vehicleNumber: "B0101", rideType: RideType(vehicleModelName: "Nexon", vehicleType: .car, facility: .ac), maxSeats: 4, fare: 150, route: [
                Schedule(address: "Sector 62", time: "7:50 AM"),
                Schedule(address: "Fortis Hospital", time: "8:05 AM"),
                Schedule(address: "Sector 52", time: "8:15 AM"),
                Schedule(address: "Sector 32", time: "8:25 AM"),
                Schedule(address: "Golf Course", time: "8:40 AM"),
                Schedule(address: "Sector 37", time: "8:50 AM"),
                Schedule(address: "Axis House", time: "9:15 AM"),
                Schedule(address: "Pari Chowk", time: "9:20 AM")
            ])
            
            ]
        
        availableRides = [
            RidesAvailable(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "8:45 AM"), fare: 45, date: "20/01/2025", seatsAvailable: 30, serviceProvider: allServiceProviders[0] , rating: 3.5),
            RidesAvailable(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "8:45 AM"), fare: 75, date: "20/01/2025", seatsAvailable: 3, serviceProvider: allServiceProviders[2] , rating: 4.9),
            RidesAvailable(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "8:45 AM"), fare: 65, date: "20/01/2025", seatsAvailable: 40, serviceProvider: allServiceProviders[3] , rating: 4.6),
            RidesAvailable(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "8:45 AM"), fare: 135, date: "20/01/2025", seatsAvailable: 4, serviceProvider: allServiceProviders[4] , rating: 4.1),
            RidesAvailable(source: Schedule(address: "Sector 62", time: "8:00 AM"), destination: Schedule(address: "Pari Chowk", time: "9:30 AM"), fare: 90, date: "20/01/2025", seatsAvailable: 35, serviceProvider: allServiceProviders[5] , rating: 3.9),
            RidesAvailable(source: Schedule(address: "Sector 62", time: "8:00 AM"), destination: Schedule(address: "Pari Chowk", time: "9:30 AM"), fare: 150, date: "18/01/2025", seatsAvailable: 3, serviceProvider: allServiceProviders[6] , rating: 4.8)
        ]
        
        
        
        ridesHistory = [
            RideHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "17/01/2025", fare: 150, seatNumber: nil),
            RideHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "18/01/2025", fare: 30, seatNumber: 21),
            RideHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "19/01/2025", fare: 40, seatNumber: 1),
            RideHistory(source: Schedule(address: "Knowledge Park-II", time: "8:05 AM"), destination: Schedule(address: "Okhla Bird Sanctuary", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "20/01/2025", fare: 45, seatNumber: 3),
            RideHistory(source: Schedule(address: "Sector 62", time: "7:50 AM"), destination: Schedule(address: "Pari Chowk", time: "9:20 AM"), serviceProvider: allServiceProviders[6], date: "28/01/2025", fare: 150, seatNumber: nil),
            RideHistory(source: Schedule(address: "Pari Chowk", time: "8:00 AM"), destination: Schedule(address: "Botanical Garden", time: "9:00 AM"), serviceProvider: allServiceProviders[3], date: "29/01/2025", fare: 30, seatNumber: 17),
            RideHistory(source: Schedule(address: "Mayur Vihar", time: "8:00 AM"), destination: Schedule(address: "Noida Sector 51", time: "9:00 AM"), serviceProvider: allServiceProviders[0], date: "30/01/2025", fare: 40, seatNumber: 14)
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
    
    
    //for section headers
    
    private let letsGoSectionHeaderTitles: [String] = ["Previous Rides", "Suggested Rides"]
    
    func sectionHeadersInLetsGo(at sectionNumber: Int) -> String {
        return letsGoSectionHeaderTitles[sectionNumber]
    }
  
    
    func numberOfSectionsInLetsGo() -> Int {
        return letsGoSectionHeaderTitles.count
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
        var upcomingRides = upcomingRides(for: date)
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
    
    func rideWithSimilarServiceProvider(serviceProvider: ServiceProvider)-> RidesAvailable?{
        for ride in availableRides{
            if ride.serviceProvider == serviceProvider{
                return ride
            }
        }
        return nil
    }
    
    
}

