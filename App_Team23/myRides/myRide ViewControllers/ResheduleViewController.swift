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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResheduleCell", for: indexPath) as! ResheduleCollectionViewCell
        
        cell.updateReshedulaRideData(with: indexPath)
        cell.layer.cornerRadius = 14.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in let section : NSCollectionLayoutSection
         
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            group.interItemSpacing = .fixed(10)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
