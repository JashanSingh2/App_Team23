//
//  letsGoNavigationBar.swift
//  App_Team23
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class letsGoNavigationBar: UINavigationBar {

    func setUpNavigationBar() {
        self.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        
        
        self.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        //searchBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
