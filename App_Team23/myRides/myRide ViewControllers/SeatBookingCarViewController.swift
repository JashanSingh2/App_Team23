//
//  SeatBookingCarViewController.swift
//  App_Team23
//
//  Created by Firdosh Alam on 14/02/25.
//

import UIKit

class SeatBookingCarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Registering the nib files for different sections
        let nib = UINib(nibName: "FirstNib", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CarSourceDestinationCell")
        
        let nib2 = UINib(nibName: "SecondNib", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "CarServiceDetailCell")
        
        let nib3 = UINib(nibName: "ThirdNib", bundle: nil)
        collectionView.register(nib3, forCellWithReuseIdentifier: "PassengerCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set up layout for the collection view to support dynamic item sizes
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10 // Space between rows
            layout.minimumInteritemSpacing = 10 // Space between items in a row
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // We have 3 sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Only one item in section 0
        } else if section == 1 {
            return 1 // Only one item in section 1
        } else {
            return 6 // Or dynamically change based on the number of passengers
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarSourceDestinationCell", for: indexPath)
            // Configure cell (Add any customization you need)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarServiceDetailCell", for: indexPath)
            // Configure cell (Add any customization you need)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassengerCell", for: indexPath)
            // Configure cell (Add any customization you need)
            return cell
        }
    }

    // Set the size for each item in each section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 353, height: 220) // First section
        } else if indexPath.section == 1 {
            return CGSize(width: 353, height: 240) // Second section
        } else {
            return CGSize(width: 353, height: 80) // Third section with dynamic number of items
        }
    }
}
