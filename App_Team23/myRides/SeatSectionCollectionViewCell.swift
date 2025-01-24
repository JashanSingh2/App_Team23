//
//  SeatSectionCollectionViewCell.swift
//  App_Team23
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

class SeatSectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var seatButton: UIButton!
    
    
    func updateSeatButton(with indexPath: IndexPath){
        seatButton.setTitle("\((indexPath.row + 1) + (indexPath.section * 4))", for: .normal)
        
    }
    
}
