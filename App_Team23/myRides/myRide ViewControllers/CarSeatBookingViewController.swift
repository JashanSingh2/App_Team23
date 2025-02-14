//
//  CarSeatBookingViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/02/25.
//

import UIKit

class CarSeatBookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    

    @IBOutlet weak var startingLocationLabel: UILabel!
    
    @IBOutlet weak var sourceLocationLabel: UILabel!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    @IBOutlet weak var endingLocationLabel: UILabel!
    
 
       
    @IBOutlet weak var startingTimeLabel: UILabel!
    
    @IBOutlet weak var sourceTimeLabel: UILabel!
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    @IBOutlet weak var serviceProviderNameLabel: UILabel!
    
    @IBOutlet weak var serviceProviderRatingLabel: UILabel!
    
    @IBOutlet weak var rideFareLabel: UILabel!
    
    @IBOutlet weak var vehicleDetailsLabel: UILabel!
    
    @IBOutlet weak var passengerCollectionView: UICollectionView!
    
    @IBOutlet weak var passengerScrollView: UIScrollView!
    
    @IBOutlet weak var passengerView: UIView!
    
    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passengerScrollView.contentSize = passengerView.frame.size
        

        //passengerCollectionView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        let nib = UINib(nibName: "PassengersCell", bundle: nil)
        passengerCollectionView.register(nib, forCellWithReuseIdentifier: "PassengerCell")
        
        passengerCollectionView.delegate = self
        passengerCollectionView.dataSource = self
        
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassengerCell", for: indexPath)
        
        cell.layer.cornerRadius = 14.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func generatePassengerLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in            let section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(353), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(353), heightDimension: .absolute(80))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            
            group.interItemSpacing = .fixed(10)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }

}
