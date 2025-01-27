//
//  SeatBookingViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 21/01/25.
//

import UIKit

class SeatBookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var routeView: UIView!
    
    @IBOutlet weak var seatCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewOuterView: UIView!
    
    
    @IBOutlet weak var bookButton: UIButton!
    
    var isButtonSelected = false
    
    var selectedSeats: [UIButton] = []
    let maxSeatsAllowed = 3
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookButton.isEnabled = false
        
        routeView.layer.cornerRadius = 10
        
        collectionViewOuterView.layer.cornerRadius = 8
        
        let nib = UINib(nibName: "SeatSectionCell", bundle: nil)
        seatCollectionView.register(nib, forCellWithReuseIdentifier: "SeatSectionCell")
        
        seatCollectionView.setCollectionViewLayout(generateSeatLayout(), animated: true)
        
        seatCollectionView.delegate = self
        seatCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatSectionCell", for: indexPath) as! SeatSectionCollectionViewCell
        
        cell.updateSeatButton(with: indexPath)
        cell.seatButton.addTarget(self, action: #selector(seatButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func generateSeatLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
            
            
            group.interItemSpacing = .fixed(10)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
    
     
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    
    
    
//    @objc func seatSelected(_ sender: UIButton){
//        if sender.isSelected == true{
//            sender.configuration?.baseBackgroundColor = .white
//            sender.configuration?.baseForegroundColor = .black
//            sender.isSelected = false
//            bookButton.isEnabled = false
//            
//        }else{
//            sender.configuration?.baseBackgroundColor = .systemGreen
//            sender.configuration?.baseForegroundColor = .white
//            sender.isSelected = true
//            
//            bookButton.isEnabled = true
//            
//        }
//    }
    
    
    @IBAction func bookNowButtonTapped() {
        let storyboard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "confirmVC") as! SeatBookingViewController
        navigationController?.pushViewController(viewController, animated: true)
//        let storyboard = UIStoryboard(name: "LetsGo", bundle: nil)
//        let viewController = storyboard.instantiateViewController(identifier: "SuggestedRidesViewController") as! SuggestedRidesViewController
//        //viewController.sectionNumber = sender.tag
//        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
    @objc func seatButtonTapped(_ sender: UIButton) {
            if selectedSeats.contains(sender) {
                // Deselect the seat
                deselectSeat(sender)
            } else {
                // Select the seat if within the limit
                if selectedSeats.count < maxSeatsAllowed {
                    selectSeat(sender)
                } else if selectedSeats.count == maxSeatsAllowed {
                    //bookButton.isEnabled = true
                    // Alert user if they exceed the limit
                    //showAlert()
                }
                

            }
        
        if selectedSeats.count == maxSeatsAllowed {
                    bookButton.isEnabled = true
        } else {
                bookButton.isEnabled = false
        }
        }

    @objc func selectSeat(_ seat: UIButton) {
        seat.configuration?.baseBackgroundColor = .systemGreen
        seat.configuration?.baseForegroundColor = .white
        selectedSeats.append(seat)
       }
    
    @objc func deselectSeat(_ seat: UIButton) {
        seat.configuration?.baseBackgroundColor = .white
        seat.configuration?.baseForegroundColor = .black
        if let index = selectedSeats.firstIndex(of: seat) {
            selectedSeats.remove(at: index)
        }
    }


}
