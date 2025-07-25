//
//  SeatBookingViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 21/01/25.
//

import UIKit

class SeatBookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var startingLocationLabel: UILabel!
    
    @IBOutlet weak var sourceLocationLabel: UILabel!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    @IBOutlet weak var endingLocationLabel: UILabel!
    
    @IBOutlet weak var vehicleNumberLabel: UILabel!
       
    @IBOutlet weak var startingTimeLabel: UILabel!
    
    @IBOutlet weak var sourceTimeLabel: UILabel!
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    @IBOutlet weak var routeView: UIView!
    
    @IBOutlet weak var seatCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewOuterView: UIView!
    
    
    @IBOutlet weak var bookButton: UIButton!
    
    var isButtonSelected = false
    
    var selectedRide: RidesAvailable?
    
    var selectedSeats: [UIButton] = []
    var maxSeatsAllowed: Int?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let maxSeatsAllowed{
            
        }else{
            maxSeatsAllowed = 1
        }
        
        
        bookButton.isEnabled = false
        
        routeView.layer.cornerRadius = 10
        
        collectionViewOuterView.layer.cornerRadius = 8
        
        let nib = UINib(nibName: "SeatSectionCell", bundle: nil)
        seatCollectionView.register(nib, forCellWithReuseIdentifier: "SeatSectionCell")
        
        seatCollectionView.setCollectionViewLayout(generateSeatLayout(), animated: true)
        
        
        updateUI()
        
        seatCollectionView.delegate = self
        seatCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        if let selectedRide{
            startingLocationLabel.text = selectedRide.serviceProvider.route.first?.address
            sourceLocationLabel.text = selectedRide.source.address
            destinationLocationLabel.text = selectedRide.destination.address
            endingLocationLabel.text = selectedRide.serviceProvider.route.last?.address
            
            startingTimeLabel.text = selectedRide.serviceProvider.route.first?.time
            sourceTimeLabel.text = selectedRide.source.time
            destinationTimeLabel.text = selectedRide.destination.time
            endingTimeLabel.text = selectedRide.serviceProvider.route.last?.time
            
            vehicleNumberLabel.text = selectedRide.serviceProvider.vehicleNumber
            
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let selectedRide{
            return Int(selectedRide.serviceProvider.maxSeats / 4)
        }
        return 5
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
        if let destinationVC = segue.destination as? TrackingViewController{
            destinationVC.route = (selectedRide?.serviceProvider.route)!
        }
        if let destinationVC = segue.destination as? SeatConfirmDeatilsViewController{
            destinationVC.ride = selectedRide
            destinationVC.seat = selectedSeat
        }
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
    
    var selectedSeat: [Int] = []
    @IBAction func bookNowButtonTapped() {
        //dismiss(animated: true, completion: nil)
        
        
        showAlert()
        
        
        
    }
    
    func showAlert(){
        let alert = UIAlertController(
        title: "Are you sure?",
        message: "You want to book this ride",
        preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in self.confirmRide() } ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmRide(){
     
        for seat in selectedSeats {
            selectedSeat.append(Int((seat.titleLabel?.text)!)!)
        }
        
        let ride = RideHistory(source: selectedRide!.source, destination: selectedRide!.destination, serviceProvider: selectedRide!.serviceProvider, date: "28/01/2025", fare: selectedRide!.fare * selectedSeats.count, seatNumber: selectedSeat.first)
        
        RidesDataController.shared.newRideHistory(with: ride)
        
        performSegue(withIdentifier: "rideConfirmedSegue", sender: self)
    }
    
    
    @objc func seatButtonTapped(_ sender: UIButton) {
            if selectedSeats.contains(sender) {
                // Deselect the seat
                deselectSeat(sender)
            } else {
                // Select the seat if within the limit
                if selectedSeats.count < maxSeatsAllowed! {
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
    
    @IBAction func unwindToSeatSelector(segue: UIStoryboardSegue) {
        
    }
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    

}
