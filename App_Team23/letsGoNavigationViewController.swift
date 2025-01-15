//
//  letsGoNavigationViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class letsGoNavigationViewController: UINavigationController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        navigationBar.layer.cornerRadius = 20
        
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "Search"
        
        navigationBar.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        
        navigationBar.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
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
