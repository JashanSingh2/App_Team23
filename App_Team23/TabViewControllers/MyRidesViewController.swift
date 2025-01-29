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
    
    //var preSelectedSegmentIndex:Int = 0
    
    var sectionHeaderNames:[String] = [
        "Today",
        "Tommorow",
        "Next Shedules"
    ]
    
    private var today = "28/01/2025"
    private var tomorrow = "29/01/2025"
    private var later = "30/01/2025"
    
    static var preSelectedSegmentIndex: Int = 0
    
    private var rideSelected: IndexPath!
    
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
        
        //segmentedControl.selectedSegmentIndex = preSelectedSegmentIndex
        segmentedControl.sendActions(for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = MyRidesViewController.preSelectedSegmentIndex
        collectionView.reloadData()
        MyRidesViewController.preSelectedSegmentIndex = 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return 1
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            return RidesDataController.shared.numberOfPreviousRides()
        }else {
            switch section {
            case 0:
                print("section1  " + "\(RidesDataController.shared.numberOfUpcomingRides(for: today))")
                return RidesDataController.shared.numberOfUpcomingRides(for: today)
            case 1:
                return RidesDataController.shared.numberOfUpcomingRides(for: tomorrow)
            case 2:
                return RidesDataController.shared.numberOfUpcomingRides(for: later)
                
            default:
                return RidesDataController.shared.numberOfUpcomingRides(for: today)
            }
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousSectionCell", for: indexPath) as! PreviousSectionCollectionViewCell
            let history = RidesDataController.shared.previousRides(At: indexPath.row)
            cell.updatePreviousData(with: history)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.reBookButton.addTarget(self, action: #selector(reBookButtonTapped(_:)), for: .touchUpInside)
            
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
            return cell
        }
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            let history = RidesDataController.shared.upcomingRides(At: indexPath.row, for: today)
            cell.updateSection1Data(with: history)
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
            let history = RidesDataController.shared.upcomingRides(At: indexPath.row, for: tomorrow)
            cell.updateSection2Data(with: history)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
                return cell
           
        case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            let history = RidesDataController.shared.upcomingRides(At: indexPath.row, for: later)
            cell.updateSection3Data(with: history)
            cell.layer.cornerRadius = 14.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.masksToBounds = false
                return cell
            
        default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath) as! MyRideSection1CollectionViewCell
            let history = RidesDataController.shared.upcomingRides(At: indexPath.row, for: today)
            cell.updateSection1Data(with: history)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        rideSelected = indexPath
        
        performSegue(withIdentifier: "myRidesToUpcomingRides", sender: self)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
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
    
    
    
    @IBSegueAction func rideDetailSegue(_ coder: NSCoder, sender: Any?) -> YourUpcomingRideViewController? {
        
        var rideHistory: RideHistory = RidesDataController.shared.previousRides(At: rideSelected.row)
        
        if segmentedControl.selectedSegmentIndex == 1 {
            rideHistory = RidesDataController.shared.previousRides(At: rideSelected.row)
            //return YourUpcomingRideViewController(coder: coder, rideHistory: RidesDataController.shared.previousRides(At: rideSelected.row))
        }else{
            if rideSelected.section == 0{
                rideHistory = RidesDataController.shared.upcomingRides(At: rideSelected.row, for: today)
                //return YourUpcomingRideViewController(coder: coder, rideHistory: RidesDataController.shared.upcomingRides(At: rideSelected.row, for: today))
            }else if rideSelected.section == 1{
                rideHistory = RidesDataController.shared.upcomingRides(At: rideSelected.row, for: tomorrow)
                //return YourUpcomingRideViewController(coder: coder, rideHistory: RidesDataController.shared.upcomingRides(At: rideSelected.row, for: tomorrow))
            }else{
                rideHistory = RidesDataController.shared.upcomingRides(At: rideSelected.row, for: later)
                //return YourUpcomingRideViewController(coder: coder, rideHistory: RidesDataController.shared.upcomingRides(At: rideSelected.row, for: later))
            }
        }
        YourUpcomingRideViewController.sender = segmentedControl.selectedSegmentIndex
        YourUpcomingRideViewController.rideHistory = rideHistory
        return nil
    }
    
    @objc func collectionCellTapped(_ cell: UICollectionViewCell){
        performSegue(withIdentifier: "myRidesToUpcomingRides", sender: self)
    }
    
    
    @objc func reBookButtonTapped(_ button : UIButton) {
        let storyBoard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "seatBookingVC") as! SeatBookingViewController
        navigationController?.present(viewController, animated: true)
        
    }
    
    @objc func ResheduleButtonTapped(_ button : UIButton) {
        let storyBoard = UIStoryboard(name: "MyRides", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ResheduleRides") as! ResheduleViewController
        //viewController.sectionNumber = button.tag
        navigationController?.present(viewController, animated: true)
    }
    
    @IBAction func unwindToMyrides(segue: UIStoryboardSegue) {
        MyRidesViewController.preSelectedSegmentIndex = 0
    }
    
    
    
//    @objc func ChevronButtonTapped(_ button : UIButton) {
//        let storyBoard = UIStoryboard(name: "MyRides", bundle: nil)
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "yourUpcomingRide") as! YourUpcomingRideViewController
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
    
}
