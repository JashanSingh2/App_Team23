//
//  YourUpcomingRideViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

class YourUpcomingRideViewController: UIViewController {
    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var rideDateLabel: UILabel!
    @IBOutlet weak var sourceLocationLabel: UILabel!
    @IBOutlet weak var destinationLocationLabel: UILabel!
    @IBOutlet weak var rideSourceTimeLabel: UILabel!
    @IBOutlet weak var rideDestinationTimeLabel: UILabel!
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var rideFareLabel: UILabel!
    @IBOutlet weak var vehicleTypeimageView: UIImageView!
    
    
    @IBOutlet weak var seatNumberStack: UIStackView!
    @IBOutlet weak var fareStack: UIStackView!
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var cancelRideButton: UIButton!
    
    static var rideHistory: RideHistory?
    static var sender: Int?
    
//    init?(coder: NSCoder, rideHistory: RideHistory) {
//        //print(rideHistory)
//        self.rideHistory = rideHistory
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder) {
//        print("error")
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.layer.cornerRadius = 10
        
        if YourUpcomingRideViewController.sender == 1{
            self.cancelRideButton.isHidden = true
        }
        
        UpdateCard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpdateCard()
    }
    
    func UpdateCard(){
        
        vehicleNumberLabel.layer.borderWidth = 1
        vehicleNumberLabel.layer.borderColor = view.backgroundColor?.cgColor
        vehicleNumberLabel.layer.cornerRadius = 5
      
        seatNumberStack.layer.borderWidth = 1
        seatNumberStack.layer.borderColor = view.backgroundColor?.cgColor
        seatNumberStack.layer.cornerRadius = 5
        
        fareStack.layer.borderWidth = 1
        fareStack.layer.borderColor = view.backgroundColor?.cgColor
        fareStack.layer.cornerRadius = 5
        
        if let rideHistory = YourUpcomingRideViewController.rideHistory as? RideHistory{
            
            vehicleNumberLabel.text = rideHistory.serviceProvider.vehicleNumber
            rideDateLabel.text = rideHistory.date
            sourceLocationLabel.text = rideHistory.source.address
            destinationLocationLabel.text = rideHistory.destination.address
            rideSourceTimeLabel.text = rideHistory.source.time
            rideDestinationTimeLabel.text = rideHistory.destination.time
            rideFareLabel.text = "\(rideHistory.fare)"
            if rideHistory.serviceProvider.rideType.vehicleType == .car{
                vehicleTypeimageView.image = UIImage(systemName: "car.fill")
                seatNumberLabel.text = "Not Applicable"
            }else{
                seatNumberLabel.text = "Seat No: \(rideHistory.seatNumber ?? 1)"
                vehicleTypeimageView.image = UIImage(systemName: "bus.fill")
            }
            
        }
        
       
        
        
        
    }
    
    

}
