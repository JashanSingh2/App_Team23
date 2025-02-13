//
//  RouteCell.swift
//  Ride Tracking
//
//  Created by Batch - 2 on 22/01/25.
//

import UIKit

class RouteCell: UITableViewCell {

    
    @IBOutlet weak var stopMarker: UIView!
    
    @IBOutlet weak var stopNameLabel: UILabel!
    
    
    @IBOutlet weak var stopTImeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //stopMarker.layer.cornerRadius = stopMarker.frame.height / 6
        stopMarker.clipsToBounds = true
    }

    func updateUI(with schedule: Schedule){
        stopNameLabel.text = schedule.address
        stopTImeLabel.text = schedule.time
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
