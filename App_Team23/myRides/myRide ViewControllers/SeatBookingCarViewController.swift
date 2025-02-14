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
        let nib = UINib(nibName: "CarSourceDestinationCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "First")
        
        let nib2 = UINib(nibName: "CarServiceProviderDetailCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "Second")
        
        let nib3 = UINib(nibName: "PassengersCell", bundle: nil)
        collectionView.register(nib3, forCellWithReuseIdentifier: "Third")
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set up layout for the collection view to support dynamic item sizes
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 10 // Space between rows
//            layout.minimumInteritemSpacing = 10 // Space between items in a row
//        }
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
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! CarSourceDestinationCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            //cell.layer.shadowOffset = CGSize(width: 2, height: 2)
           // cell.layer.masksToBounds = false
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! CarServiceDetailCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Third", for: indexPath) as! PassengersCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return self.generateFirstSection()
            case 1:
                return self.generateSecondSection()
            case 2:
                return self.generateThirdSection()
            default:
                return nil
            }
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            section.boundarySupplementaryItems = [header]
        }
        return layout
    }
    
    func generateFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240)) // Adjust the height as needed
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(20)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func generateSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260)) // Adjust the height as needed
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        group.interItemSpacing = .fixed(20)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func generateThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)) // Adjust the height as needed
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

}
