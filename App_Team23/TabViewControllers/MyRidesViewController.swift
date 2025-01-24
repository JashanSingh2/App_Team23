//
//  MyRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 13/01/25.
//

import UIKit

class MyRidesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var preSelectedSegmentIndex:Int = 0
    
    var sectionHeaderNames:[String] = [
        "Today",
        "Tommorow",
        "Later"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNib = UINib(nibName: "MyRideSection1Cell", bundle: nil)
        collectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        
        
        let nib = UINib(nibName: "PreviousSectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PreviousSectionCell")
        
        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        segmentedControl.selectedSegmentIndex = preSelectedSegmentIndex
        segmentedControl.sendActions(for: .valueChanged)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return 10
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            return 1
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousSectionCell", for: indexPath) as! PreviousSectionCollectionViewCell
            cell.updatePreviousData(with: indexPath)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            
            
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            return cell
        }
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            
            cell.resheduleButton.tag = indexPath.row
            cell.resheduleButton.addTarget(self, action: #selector(ResheduleButtonTapped(_:)), for: .touchUpInside)
            
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false

                return cell
            
        case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection2Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
                return cell
           
        case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection3Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
                return cell
            
        default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            cell.updateSection1Data(with: indexPath)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as! SectionHeaderCollectionReusableView
            header.headerLabel.text = sectionHeaderNames[indexPath.section]
            header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            
            return header
        }
        print("Supplementary view not found")
        return UICollectionReusableView()
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in let section : NSCollectionLayoutSection
            
            if self.segmentedControl.selectedSegmentIndex == 1 {
                
                
                section = self.generatePreviousRideLayout()
                
                
                
                return section
            }
            
            switch sectionIndex {
            case 0:
                section = self.generateUpcomingRideLayout()
            case 1:
                section = self.generateUpcomingRideLayout()
            case 2:
                section = self.generateUpcomingRideLayout()
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
    
    func generateUpcomingRideLayout() -> NSCollectionLayoutSection {
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
    
    func generatePreviousRideLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    @IBAction func previousAndUpcomingControlTapped(_ sender: Any) {
        collectionView.reloadData()
    }
    
    @objc func ResheduleButtonTapped(_ button : UIButton) {
        let storyBoard = UIStoryboard(name: "MyRides", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ResheduleRides") as! ResheduleViewController
        //viewController.sectionNumber = button.tag
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
