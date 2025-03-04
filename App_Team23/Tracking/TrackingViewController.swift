//
//  ViewController.swift
//  Ride Tracking
//
//  Created by Batch - 2 on 22/01/25.
//

import UIKit

class TrackingViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainviewOutlet: UIView!
    
    @IBOutlet weak var BusNumberOutlet: UILabel!
    
    var route: [Schedule] = []
        
    @IBOutlet weak var tableView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        mainviewOutlet.layer.cornerRadius = 12
        mainviewOutlet.layer.cornerRadius = 12.0
        mainviewOutlet.layer.shadowColor = UIColor.black.cgColor
        mainviewOutlet.layer.shadowOpacity = 0.5
        mainviewOutlet.layer.shadowRadius = 2.5
        mainviewOutlet.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainviewOutlet.layer.masksToBounds = false
        
        BusNumberOutlet.layer.borderWidth = 1
        BusNumberOutlet.layer.borderColor = UIColor.black.cgColor
        BusNumberOutlet.layer.cornerRadius = 5
        tableView.register(UINib(nibName: "RideTrackingTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as? RouteCell else {
            return UITableViewCell()
        }

        let stop = route[indexPath.row]
        
        cell.updateUI(with: stop)
        
        return cell
    }

   


}

