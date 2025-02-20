//
//  CarSourceDestinationCollectionViewCell.swift
//  App_Team23
//
//  Created by Firdosh Alam on 14/02/25.
//

import UIKit

class CarSourceDestinationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var startingLocationLabel: UILabel!
    
    @IBOutlet weak var sourceLocationLabel: UILabel!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    @IBOutlet weak var endingLocationLabel: UILabel!
    
 
       
    @IBOutlet weak var startingTimeLabel: UILabel!
    
    @IBOutlet weak var sourceTimeLabel: UILabel!
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    
    func updateUI(with route: [Schedule],source: Schedule, destination: Schedule){
        startingLocationLabel.text = route.first?.address
        startingTimeLabel.text = route.first?.time
        
        sourceLocationLabel.text = source.address
        sourceTimeLabel.text = source.time
        
        destinationLocationLabel.text = destination.address
        destinationTimeLabel.text = destination.time
        
        endingLocationLabel.text = route.last?.address
        endingTimeLabel.text = route.last?.time
        
        
        
    }
    
    
}
