//
//  LoginSecurityViewController.swift
//  AccountSection
//
//  Created by Batch- 1 on 16/01/25.
//

import UIKit

class LoginSecurityViewController: UIViewController {
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deactivateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Login & Security"
        updateButton.layer.cornerRadius = 15
        updateButton.clipsToBounds = true
        deactivateButton.layer.cornerRadius = 15
        deactivateButton.clipsToBounds = true
    }
    
    
}
