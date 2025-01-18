//
//  LetsGoViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 10/01/25.
//

import UIKit

class LetsGoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    
    @IBOutlet var letsGoCollectionView: UICollectionView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding search bar
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Where are you going?"
        
        
        
        navigationItem.searchController = searchController
        //Adding xib files to collection view
        let firstNib = UINib(nibName: "PreviousRides", bundle: nil)
        let secondNib = UINib(nibName: "SuggestedRides", bundle: nil)
        
        letsGoCollectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        
        letsGoCollectionView.register(secondNib, forCellWithReuseIdentifier: "Second")
        
        letsGoCollectionView.register(LetsGoCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LetsGoCollectionReusableView")
        
        letsGoCollectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        letsGoCollectionView.delegate = self
        letsGoCollectionView.dataSource = self
        
        
        }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RidesDataController.shared.numberOfSectionsInLetsGo()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 3
            case 1:
                return 4
            default:
                return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! HomeScreenPreviousRidesCollectionViewCell
                cell.updatePreviousRideCell(with: indexPath)
                cell.layer.cornerRadius = 14
                return cell
            case 1:
                let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! HomeScreenSuggestedRidesCollectionViewCell
                cell.updateSuggestedRideCell(with: indexPath)
                cell.layer.cornerRadius = 14
                return cell
            default:
                let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! HomeScreenPreviousRidesCollectionViewCell
                cell.updatePreviousRideCell(with: indexPath)
                cell.layer.cornerRadius = 14
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = letsGoCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LetsGoCollectionReusableView", for: indexPath) as! LetsGoCollectionReusableView
            header.headerLabel.text = RidesDataController.shared.sectionHeadersInLetsGo(at: indexPath.section)
            header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            
            header.button.setTitle("See All", for: .normal)
            header.button.tag = indexPath.section
            if indexPath.section == 1 {
                header.button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            }
            
            header.button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            
            header.button.semanticContentAttribute = .forceRightToLeft
            
            return header
        }
        print("Supplementry View Not Found")
        return UICollectionReusableView()
    }
    
    func generateLayout()-> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex, environment)-> NSCollectionLayoutSection? in let section: NSCollectionLayoutSection
                switch sectionIndex{
                    case 0:
                        section = self.generatePreviousRidesLayout()
                    default:
                        section = self.generateSuggestedRidesLayout()
                }
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    func generatePreviousRidesLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(380), heightDimension: .absolute(175))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
        
    }
    
    
    func generateSuggestedRidesLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
        
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
    
    @IBAction func unwindToLetsGo(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LetsGo", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SuggestedRidesViewController") as! SuggestedRidesViewController
        viewController.sectionNumber = sender.tag
        navigationController?.pushViewController(viewController, animated: true)
    }
}



