//
//  MyRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import UIKit

class MyRidesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var myRideCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNib = UINib(nibName: "MyRideSection1Cell", bundle: nil)
        let secondNib = UINib(nibName: "MyRideSection2Cell", bundle: nil)
        
        myRideCollectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        myRideCollectionView.register(secondNib, forCellWithReuseIdentifier: "Second")
        
        myRideCollectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
        
        myRideCollectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        myRideCollectionView.delegate = self
        myRideCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 8.0
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! MyRideSection2CollectionViewCell
            cell.updateSection2Data(with: indexPath)
            cell.layer.cornerRadius = 8.0
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Third", for: indexPath) as! MyRideSection3CollectionViewCell
            cell.updateSection3Data(with: indexPath)
            cell.layer.cornerRadius = 8.0
                return cell
            default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection3CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 8.0
                return cell
        }
    }
    
    func generateLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in let section : NSCollectionLayoutSection
            
            switch sectionIndex {
            case 0:
                section = self.generateSection1Layout()
            default :
                print("Default")
                return nil
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    func generateSection1Layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(8.0)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func generateSection2Layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: item, count: 2)
        
        gr
    }
}
