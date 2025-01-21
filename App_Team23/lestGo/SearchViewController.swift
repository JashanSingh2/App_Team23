//
//  SearchViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit
import MapKit


class SearchViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var modalVCView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.showsUserLocation = true
        
        //modalVCView.isHidden = true
        
        let modalVC = ModelContentViewController()
        modalVC.modalPresentationStyle = .pageSheet
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(),.large()]
            
        }
        //modalVC.view.backgroundColor = .white
        modalVC.view.addSubview(modalVCView)
        //modalVC.modalOuterView.isHidden = false
        
        present(modalVC, animated: true)
        
        
        
        
        
        //mapView.layer.
        // Do any additional setup after loading the view.
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
