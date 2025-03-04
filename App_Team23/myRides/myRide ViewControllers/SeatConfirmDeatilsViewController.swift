//
//  SeatConfirmDeatilsViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 27/01/25.
//

import UIKit
import App_Team23

class SeatConfirmDeatilsViewController: UIViewController {
   
    @IBOutlet weak var busOrCarImageView: UIImageView!
    
    
    @IBOutlet weak var vehicleNumLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sourceAddressLabel: UILabel!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    
    @IBOutlet weak var sourceTimeLabel: UILabel!
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    
    @IBOutlet weak var seatNoLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var seatNoStackView: UIStackView!
    

//    var ride: RideHistory?

    var ride: RidesHistory?
    var seat: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let ride{
            updateUI()
        }
        if let seat{
            seatNoLabel.text = "Seat No : \(seat)"
        } else {
            seatNoStackView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        vehicleNumLabel.text = ride!.serviceProvider.vehicleNumber
        sourceAddressLabel.text = ride!.source.address
        destinationAddressLabel.text = ride!.destination.address
        dateLabel.text = ride!.date
        sourceTimeLabel.text = ride!.source.time
        destinationTimeLabel.text = ride!.destination.time
        fareLabel.text = "\(ride!.fare * (seat?.count ?? 1))"
        
        if ride?.serviceProvider.rideType.vehicleType == .bus{
            busOrCarImageView.image = UIImage(systemName: "bus.fill")
        }else{
            busOrCarImageView.image = UIImage(systemName: "car.fill")
        }
    }
    
    

}
