//
//  SeatBookingCarViewController.swift
//  App_Team23
//
//  Created by Firdosh Alam on 14/02/25.
//

import UIKit

class SeatBookingCarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var passengerCount: Int = 4
    
    var sectionHeaderNames: [String] =
    ["",
     "Service Provider",
     "Passengers Details",
     ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Registering the nib files for different sections
        let nib = UINib(nibName: "CarSourceDestinationCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "First")
        
        let nib2 = UINib(nibName: "CarServiceProviderDetailCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "Second")
        
        let nib3 = UINib(nibName: "PassengersCell", bundle: nil)
        collectionView.register(nib3, forCellWithReuseIdentifier: "Third")
        
        let nib4 = UINib(nibName: "CarBookNowButtonCell", bundle: nil)
        collectionView.register(nib4, forCellWithReuseIdentifier: "Fourth")
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)

        collectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionReusableView")
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else  if section == 2 {
            return passengerCount
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as! SectionHeaderCollectionReusableView
            
            header.headerLabel.text = sectionHeaderNames[indexPath.section].uppercased()
            header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
           // header.headerLabel.frame = CGRect(x: 0, y: 20, width: header.frame.width, height: header.frame.height)
            return header
        }
        print("Supplementary view not found")
        return UICollectionReusableView()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! CarSourceDestinationCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            
            
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! CarServiceProviderDetailCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            
                        
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Third", for: indexPath) as! PassengersCollectionViewCell
            
            cell.layer.cornerRadius = 14
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fourth", for: indexPath) as! CarBookNowButtonCollectionViewCell
            
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in //let section: NSCollectionLayoutSection
            
            switch sectionIndex {
            case 0:
                return self.generateFirstSection()
            case 1:
                return self.generateSecondSection()
            case 2:
                return self.generateThirdSection()
            case 3:
                return self.generateFourthSection()
            default:
                return nil
            }
            
//            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
//            
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(64)) // Adjust height as needed
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                        layoutSize: headerSize,
//                        elementKind: UICollectionView.elementKindSectionHeader,
//                        alignment: .topLeading
//                    )
//                    
//            section.boundarySupplementaryItems = [header]
//            return section
        }
        return layout
    }
    
    func generateFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        section.boundarySupplementaryItems = [header]
        
        return section
    }

    func generateSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260)) // Adjust the height as needed
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    func generateThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func generateFourthSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        //group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        //section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
        
    }

}
