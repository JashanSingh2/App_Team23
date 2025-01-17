//
//  MyRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import UIKit

class MyRidesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNib = UINib(nibName: "MyRideSection1Cell", bundle: nil)
        let secondNib = UINib(nibName: "MyRideSection2Cell", bundle: nil)
        let thirdNib = UINib(nibName: "MyRideSection3Cell", bundle: nil)
        
        collectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        collectionView.register(secondNib, forCellWithReuseIdentifier: "Second")
        collectionView.register(thirdNib, forCellWithReuseIdentifier: "Third")
        
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
//            cell.layer.shadowColor = UIColor.black.cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//            cell.layer.shadowOpacity = 0.2
//
                return cell
            
        case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! MyRideSection2CollectionViewCell
            cell.updateSection2Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
                return cell
           
        case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Third", for: indexPath) as! MyRideSection3CollectionViewCell
            cell.updateSection3Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
                return cell
            
        default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as! SectionHeaderCollectionReusableView
            header.headerLabel.text = "Today"
            header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            
            return header
        }
        print("Supplementary view not found")
        return UICollectionReusableView()
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in let section : NSCollectionLayoutSection
            
            switch sectionIndex {
            case 0:
                section = self.generateSection1Layout()
            case 1:
                section = self.generateSection2Layout()
            case 2:
                section = self.generateSection3Layout()
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func generateSection2Layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func generateSection3Layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
}
