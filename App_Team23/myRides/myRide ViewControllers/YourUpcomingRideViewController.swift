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
    
    @IBOutlet weak var seatNumberStack: UIStackView!
    @IBOutlet weak var fareStack: UIStackView!
    @IBOutlet weak var cardView: UIView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 10
        
        UpdateCard()
        // Do any additional setup after loading the view.
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
        
        
    }
    
    

}
