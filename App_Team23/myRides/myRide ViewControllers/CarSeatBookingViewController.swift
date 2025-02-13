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
    
    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nib = UINib(nibName: "PassengersCell", bundle: nil)
        passengerCollectionView.register(nib, forCellWithReuseIdentifier: "PassengerCell")
        
        passengerCollectionView.delegate = self
        passengerCollectionView.dataSource = self
       
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassengerCell", for: indexPath)
        return cell
    }
    
    func generatePassengerLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
            
            
            group.interItemSpacing = .fixed(10)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }

}
