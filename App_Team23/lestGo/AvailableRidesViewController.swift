//
//  AvailableRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit
import MapKit



class AvailableRidesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    //@IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var routeMapView: MKMapView!
    
    
    @IBOutlet weak var availableRidesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //routeMapView.layer.cornerRadius = 18
        
        availableRidesCollectionView.layer.cornerRadius = 18
        
        //bottomView.layer.cornerRadius = 15
        
        let nib = UINib(nibName: "AllSuggestedRides", bundle: nil)
        
        availableRidesCollectionView.register(nib, forCellWithReuseIdentifier: "AvailableRides")
        
        availableRidesCollectionView.setCollectionViewLayout(generatelayout(), animated: true)
        
        availableRidesCollectionView.dataSource = self
        availableRidesCollectionView.delegate = self
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = availableRidesCollectionView.dequeueReusableCell(withReuseIdentifier: "AvailableRides", for: indexPath) as! AllSuggestedRidesCollectionViewCell
        cell.updateAllSuggestedRidesCell(with: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "seatBookingVC") as! SeatBookingViewController
        navigationController?.pushViewController(viewController, animated: true)
//        performSegue(withIdentifier: "AvailableRidesToSeatBooking", sender: self)
    }
    
    
    func generatelayout()-> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex, environment)-> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
            
            return section
            
        }
        
        return layout
    }
    

    @IBAction func unwindToRideSelection(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    

}
