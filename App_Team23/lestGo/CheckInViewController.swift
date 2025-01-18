//
//  CheckInViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 18/01/25.
//

import UIKit

class CheckInViewController: UIViewController {

    
    @IBOutlet weak var QRTicketImage: UIImageView!
    
    
    @IBOutlet weak var rideTypeImageView: UIImageView!
    
    @IBOutlet weak var vehicleNumberLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sourceAddressLabel: UILabel!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    
    @IBOutlet weak var pickupTimeLabel: UILabel!
    
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    
    @IBOutlet weak var seatsNumLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var seatsAvailableStackView: UIStackView!
    
    @IBOutlet weak var fareStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vehicleNumberLabel.layer.borderColor = view.backgroundColor?.cgColor
        vehicleNumberLabel.layer.borderWidth = 1
        vehicleNumberLabel.layer.cornerRadius = 5
        
        seatsAvailableStackView.layer.borderColor = view.backgroundColor?.cgColor
        seatsAvailableStackView.layer.borderWidth = 1
        seatsAvailableStackView.layer.cornerRadius = 5
        
        
        fareStackView.layer.borderColor = view.backgroundColor?.cgColor
        fareStackView.layer.borderWidth = 1
        fareStackView.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
