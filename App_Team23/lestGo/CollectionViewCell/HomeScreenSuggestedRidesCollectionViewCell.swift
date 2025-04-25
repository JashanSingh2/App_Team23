//
//  HomeScreenSuggestedRidesCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 17/01/25.
//

import UIKit

class HomeScreenSuggestedRidesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sourceAddressLabel: UILabel!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    
//    @IBOutlet weak var seatsAvailableLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var busOrCarButton: UIButton!
    
    @IBOutlet weak var seatAvailableButton: UIButton!
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateSuggestedRideCell(with ride: (provider: ServiceProviderDetails2, history: RidesHistory2)) {
        sourceAddressLabel.text = ride.history.source
        destinationAddressLabel.text = ride.history.destination
        
        // Using the ride date for both pickup and dropoff times
        pickUpTimeLabel.text = timeFormatter.string(from: ride.history.date)
        dropOffTimeLabel.text = timeFormatter.string(from: ride.history.date)
        
        // Set vehicle type icon and text
        let config = UIImage.SymbolConfiguration(scale: .medium)
        if ride.provider.vehicleType == .bus {
            let image = UIImage(systemName: "bus.fill", withConfiguration: config)
            busOrCarButton.setImage(image, for: .normal)
            busOrCarButton.setTitle("Bus", for: .normal)
        } else {
            let image = UIImage(systemName: "car.fill", withConfiguration: config)
            busOrCarButton.setImage(image, for: .normal)
            busOrCarButton.setTitle("Car", for: .normal)
        }
        
        // You'll need to implement getAvailableSeats in SupabaseDataController2
        Task {
            do {
                let seatsAvailable = try await SupabaseDataController2.shared.getAvailableSeats(for: ride.provider.id)
                DispatchQueue.main.async {
                    self.seatAvailableButton.setTitle("\(seatsAvailable) Seats", for: .normal)
                }
            } catch {
                print("Error fetching available seats: \(error)")
                DispatchQueue.main.async {
                    self.seatAvailableButton.setTitle("-- Seats", for: .normal)
                }
            }
        }
        
        fareLabel.text = "₹\(ride.provider.fare)"
    }
    
}
