//
//  SuggestedRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 17/01/25.
//

import UIKit

class SuggestedRidesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var rides: [(RideAvailable, Schedule, Schedule,Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AllSuggestedRides", bundle: nil)
        
        
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllSuggestedRidesCollectionViewCell
        let ride = RidesDataController.shared.availableRide(At: indexPath.row)
        cell.updateAllSuggestedRidesCell(with: ride)
        cell.layer.cornerRadius = 12.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.masksToBounds = false
        return cell
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, environment)-> NSCollectionLayoutSection? in let section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(236))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            group.interItemSpacing = .fixed(8)
            group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 6, bottom: 0, trailing: 6)
            
            
            section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
    
    

}
