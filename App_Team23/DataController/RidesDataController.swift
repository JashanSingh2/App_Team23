//
//  RidesDataController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import Foundation

struct RidesDataController {
    
    static var shared = RidesDataController()
    
    
    private var allServiceProviders: [ServiceProvider] = [
        ServiceProvider(name: "Anuj", vehicleNumber: "A1035", rideType: RideType(vehicleModelName: "Force Traveller", vehicleType: .bus, facility: .nonAc), maxSeats: 35, fare: 45, route: [
            Schedule(address: "Akshardham", dateAndTime: DateAndTime(date: "16/01/2025", time: "7:40AM")),
            Schedule(address: "Yamuna Bank", dateAndTime: DateAndTime(date: "16/01/2025", time: "7:50Am")),
            Schedule(address: "Mayur Vihar 1", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:00AM")),
            Schedule(address: "Ashok Nagar", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:05AM")),
            Schedule(address: "Noida Sec-15", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:15AM")),
            Schedule(address: "Noida Sec-18", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:25AM")),
            Schedule(address: "Botanical Garden", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:30AM")),
            Schedule(address: "Noida City Centre", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:40AM")),
            Schedule(address: "Noida Sec-51", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:45AM")),
            Schedule(address: "Noida Sec-62", dateAndTime: DateAndTime(date: "16/01/2025", time: "9:10AM"))
        ]),
        ServiceProvider(name: "Aryan", vehicleNumber: "B1035", rideType: RideType(vehicleModelName: "Suzuki Dzire", vehicleType: .car, facility: .nonAc), maxSeats: 35, fare: 85, route: [
            Schedule(address: "Akshardham", dateAndTime: DateAndTime(date: "16/01/2025", time: "7:40AM")),
            Schedule(address: "Yamuna Bank", dateAndTime: DateAndTime(date: "16/01/2025", time: "7:50Am")),
            Schedule(address: "Mayur Vihar 1", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:00AM")),
            Schedule(address: "Ashok Nagar", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:05AM")),
            Schedule(address: "Noida Sec-15", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:15AM")),
            Schedule(address: "Noida Sec-18", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:25AM")),
            Schedule(address: "Botanical Garden", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:30AM")),
            Schedule(address: "Noida City Centre", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:40AM")),
            Schedule(address: "Noida Sec-51", dateAndTime: DateAndTime(date: "16/01/2025", time: "8:45AM")),
            Schedule(address: "Noida Sec-62", dateAndTime: DateAndTime(date: "16/01/2025", time: "9:10AM"))
        ]),
        ServiceProvider(name: "Firdosh", vehicleNumber: "A9999", rideType: RideType(vehicleModelName: "Volvo", vehicleType: .bus, facility: .ac), maxSeats: 45, fare: 65, route: [
            Schedule(address: "Pari Chowk", dateAndTime: DateAndTime(date: "16/01/2025", time: ""))
        ])
    ]
    
    private var availableRides: [RidesAvailable] = [
//        RidesAvailable(source: Schedule(address: "Mayur Vihar 1", dateAndTime: <#T##DateAndTime#>), destination: Schedule(address: <#T##String#>, dateAndTime: <#T##DateAndTime#>), fare: <#T##Double#>, date: <#T##String#>, seatsAvailable: <#T##Int#>, serviceProvider: <#T##ServiceProvider#>, rating: <#T##Double#>)
    ]
    
    private let letsGoSectionHeaderTitles: [String] = ["Previous Rides", "Suggested Rides"]
    
    func sectionHeadersInLetsGo(at sectionNumber: Int) -> String {
        return letsGoSectionHeaderTitles[sectionNumber]
    }
    
    func numberOfSectionsInLetsGo() -> Int {
        return letsGoSectionHeaderTitles.count
    }
    
    
}

