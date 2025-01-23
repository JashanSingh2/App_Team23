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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        routeView.layer.cornerRadius = 10
        
        let nib = UINib(nibName: "SeatSectionCell", bundle: nil)
        seatCollectionView.register(nib, forCellWithReuseIdentifier: "SeatSectionCell")
        
        seatCollectionView.setCollectionViewLayout(generateSeatLayout(), animated: true)
        
        seatCollectionView.delegate = self
        seatCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatSectionCell", for: indexPath) as! SeatSectionCollectionViewCell
        
        cell.updateSeatButton(with: indexPath)
        return cell
    }
    
    func generateSeatLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(30), heightDimension: .absolute(30))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(30))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 10)
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

}
