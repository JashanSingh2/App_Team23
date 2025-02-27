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
        mainviewOutlet.layer.cornerRadius = 20
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

