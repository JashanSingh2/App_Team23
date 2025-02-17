//
//  rideSearchTableViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 21/01/25.
//

import UIKit

class rideSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateCell(With address: String){
        addressLabel.text = address
    }
    
    
}
