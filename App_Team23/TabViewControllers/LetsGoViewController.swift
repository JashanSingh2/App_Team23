//
//  LetsGoViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 10/01/25.
//

import UIKit

class LetsGoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchControllerDelegate {
    
    @IBOutlet var letsGoCollectionView: UICollectionView!
  
    
    let searchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        searchController.delegate = self
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        letsGoCollectionView.reloadData()
    }
    
    
    func willPresentSearchController(_ searchController: UISearchController) {
        performSegue(withIdentifier: "searchBar", sender: self)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RidesDataController.shared.numberOfSectionsInLetsGo()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return RidesDataController.shared.numberOfBusRidesInHistory()
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
                let RideHistory = RidesDataController.shared.rideHistoryOfBus(At: indexPath.row)
                
                cell.reBookButton.tag = indexPath.row
                cell.reBookButton.addTarget(self, action: #selector(reBookButtonTapped), for: .touchUpInside)
                cell.updatePreviousRideCell(with: RideHistory)
                print(RideHistory.date)
                cell.layer.cornerRadius = 14
                return cell
            case 1:
                let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! HomeScreenSuggestedRidesCollectionViewCell
                let rideSuggestion = RidesDataController.shared.rideSuggestion(At: indexPath.row)
                cell.updateSuggestedRideCell(with: rideSuggestion)
                cell.layer.cornerRadius = 14
                return cell
            default:
                let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! HomeScreenPreviousRidesCollectionViewCell
                let RideHistory = RidesDataController.shared.rideHistoryOfBus(At: indexPath.item)
                print(RideHistory.date)
                cell.updatePreviousRideCell(with: RideHistory)
                cell.layer.cornerRadius = 14
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "LetsGoCollectionReusableView",
                    for: indexPath
                ) as! LetsGoCollectionReusableView
                
                header.headerLabel.text = RidesDataController.shared.sectionHeadersInLetsGo(at: indexPath.section)
                header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
                
                if indexPath.section == 1 {
                    header.button.isHidden = false  // Ensure button is visible
                    header.button.setTitle("See All", for: .normal)
                    header.button.tag = indexPath.section
                    header.button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
                    header.button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
                    header.button.semanticContentAttribute = .forceRightToLeft
                } else {
                    header.button.isHidden = true
                    header.button.removeTarget(nil, action: nil, for: .allEvents)
                }
                
                return header

            default:
                return UICollectionReusableView()
        }
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .absolute(175))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
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
        if sender.tag == 1 {
            let storyboard = UIStoryboard(name: "LetsGo", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "SuggestedRidesViewController") as! SuggestedRidesViewController
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    var selectedRide: RideHistory?
    
    @objc func reBookButtonTapped(_ button : UIButton) {
        selectedRide = RidesDataController.shared.rideHistoryOfBus(At: button.tag)
        
        let storyBoard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "seatBookingVC") as! SeatBookingViewController
        navigationController?.present(viewController, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seatVC = segue.destination as? SeatBookingViewController{
            //notesVC.dataController = dataController
//            if let selectedNoteBook = notebooksTableView.indexPathForSelectedRow{
//                notesVC.selectedNoteBook = notebooks[selectedNoteBook.row]
//            }
            seatVC.selectedRide = RidesDataController.shared.rideWithSimilarServiceProvider(serviceProvider: selectedRide!.serviceProvider)
            
        }
    }
     
}

