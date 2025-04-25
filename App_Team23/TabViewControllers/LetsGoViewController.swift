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
    let supabase = SupabaseDataController2.shared
    
    private let letsGoSectionHeaderTitles: [String] = ["Recent Rides", "Suggested Rides"]
    private var recentRides: [RidesHistory2] = []
    private var suggestedRides: [(provider: ServiceProviderDetails2, history: RidesHistory2)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.placeholder = "Where are you going?"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Adding xib files to collection view
        let firstNib = UINib(nibName: "PreviousRides", bundle: nil)
        let secondNib = UINib(nibName: "SuggestedRides", bundle: nil)
        
        letsGoCollectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        letsGoCollectionView.register(secondNib, forCellWithReuseIdentifier: "Second")
        letsGoCollectionView.register(LetsGoCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "LetsGoCollectionReusableView")
        
        letsGoCollectionView.setCollectionViewLayout(generateLayout(), animated: true)
        letsGoCollectionView.delegate = self
        letsGoCollectionView.dataSource = self
        searchController.delegate = self
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        Task {
            do {
                // Get logged in user
                guard let userId = UserDefaults.standard.string(forKey: "userId"),
                      let userUUID = UUID(uuidString: userId) else {
                    return
                }
                
                // Load recent rides
                recentRides = try await supabase.getRecentRides(userId: userUUID)
                
                // Load suggested rides for today
                let today = supabase.getTodayDate()
                suggestedRides = try await supabase.getSuggestedRides(source: "", destination: "")
                
                DispatchQueue.main.async {
                    self.letsGoCollectionView.reloadData()
                }
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        performSegue(withIdentifier: "searchBar", sender: self)
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return letsGoSectionHeaderTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return recentRides.count
        case 1:
            return suggestedRides.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! HomeScreenPreviousRidesCollectionViewCell
            let rideHistory = recentRides[indexPath.row]
            
            cell.reBookButton.tag = indexPath.row
            cell.reBookButton.addTarget(self, action: #selector(reBookButtonTapped), for: .touchUpInside)
            cell.updatePreviousRideCell(with: rideHistory)
            
            cell.layer.cornerRadius = 12.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 2.5
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.masksToBounds = false
            
            return cell
            
        case 1:
            let cell = letsGoCollectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! HomeScreenSuggestedRidesCollectionViewCell
            let rideSuggestion = suggestedRides[indexPath.row]
            
            cell.selectButton.tag = indexPath.row
            cell.selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
            cell.updateSuggestedRideCell(with: rideSuggestion)
            
            cell.layer.cornerRadius = 12.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 2.5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - Collection View Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "LetsGoCollectionReusableView",
                for: indexPath
            ) as! LetsGoCollectionReusableView
            
            header.headerLabel.text = letsGoSectionHeaderTitles[indexPath.section]
            header.headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            
            if indexPath.section == 1 {
                header.button.isHidden = false
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
    
    // MARK: - Layout
    
    func generateLayout() -> UICollectionViewLayout {
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(245), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
        
    }
    
    
    func generateSuggestedRidesLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        //group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
    
    // MARK: - Actions
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            performSegue(withIdentifier: "SRVC", sender: self)
        }
    }
    
    @objc func selectButtonTapped(_ button: UIButton) {
        let selectedRide = suggestedRides[button.tag]
        if selectedRide.provider.vehicleType == .bus {
            performSegue(withIdentifier: "seatReBooking", sender: selectedRide)
        } else if selectedRide.provider.vehicleType == .car {
            performSegue(withIdentifier: "carBookingSegue", sender: selectedRide)
        }
    }
    
    @objc func reBookButtonTapped(_ button: UIButton) {
        let selectedRecentRide = recentRides[button.tag]
        
        Task {
            do {
                let availableRides = try await supabase.searchRides(
                    source: selectedRecentRide.source,
                    destination: selectedRecentRide.destination,
                    date: supabase.getTodayDate()
                )
                
                if !availableRides.isEmpty {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "seatReBooking", sender: availableRides[0])
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            } catch {
                print("Error searching rides: \(error)")
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let busVC = segue.destination as? SeatBookingViewController,
//           let selectedRide = sender as? (ride: RidesAvailable2, provider: ServiceProviderDetails2) {
//            busVC.selectedRide = selectedRide
//            busVC.source = selectedRide.provider.routeId // You'll need to fetch route details
//            busVC.destination = selectedRide.provider.routeId // You'll need to fetch route details
//        }
//        
//        if let carVC = segue.destination as? SeatBookingCarViewController,
//           let selectedRide = sender as? (ride: RidesAvailable2, provider: ServiceProviderDetails2) {
//            carVC.selectedRide = selectedRide
//        }
//        
//        if let suggestedRidesVC = segue.destination as? SuggestedRidesViewController {
//            suggestedRidesVC.rides = suggestedRides
//        }
//    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "No Rides Available",
            message: "No rides are available for today. Please try again later",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

