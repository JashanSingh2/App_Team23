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
    
    let stops: [RouteStop] = [
        RouteStop(stopName: "Akshardham", stopTime: "7:40 AM"),
        RouteStop(stopName: "Yamuna Bank", stopTime: "7:50 AM"),
        RouteStop(stopName: "Mayur Vihar 1", stopTime: "8:00 AM"),
        RouteStop(stopName: "Ashok Nagar", stopTime: "8:05 AM"),
        RouteStop(stopName: "Sector 15", stopTime: "8:15 AM"),
        RouteStop(stopName: "Sector 18", stopTime: "8:25 AM"),
        RouteStop(stopName: "Botanical Garden", stopTime: "8:30 AM"),
        RouteStop(stopName: "Noida City Center", stopTime: "8:40 AM"),
        RouteStop(stopName: "Sector 51", stopTime: "8:45 AM"),
        RouteStop(stopName: "Sector 62", stopTime: "9:10 AM"),
        RouteStop(stopName: "Secotor 63", stopTime: "9:20 AM")
        
    ]
        
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
        return stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as? RouteCell else {
            return UITableViewCell()
        }

        let stop = stops[indexPath.row]
        cell.stopNameLabel.text = stop.stopName
        cell.stopTImeLabel.text = stop.stopTime
       
        return cell
    }

   


}

