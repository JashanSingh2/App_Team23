//
//  ResheduleViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class ResheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var resheduleViewController: UICollectionView!
    //    var sectionNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        let nibFirst = UINib(nibName: "ResheduleSectionCell", bundle: nil)
        resheduleViewController.register(nibFirst, forCellWithReuseIdentifier: "ResheduleCell")
        
        resheduleViewController.setCollectionViewLayout(generateLayout(), animated: true)
        
        resheduleViewController.delegate = self
        resheduleViewController.dataSource = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResheduleCell", for: indexPath) as! ResheduleCollectionViewCell
        
        cell.updateReshedulaRideData(with: indexPath)
        
        cell.selectButton.addTarget(self, action: #selector(selectButtonTapped(_:)), for: .touchUpInside)
        
        cell.layer.cornerRadius = 12.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in let section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            group.interItemSpacing = .fixed(10)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
    
    
    @objc func selectButtonTapped(_ button : UIButton) {
        let storyBoard = UIStoryboard(name: "SeatBookingViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "seatBookingVC") as! SeatBookingViewController
        navigationController?.present(viewController, animated: true)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
