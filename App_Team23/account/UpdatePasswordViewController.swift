//
//  UpdatePassowdViewController.swift
//  App_Team23
//
//  Created by Batch- 1 on 21/02/25.
//

import UIKit

class UpdatePasswordViewController: UIViewController {

    
    @IBOutlet weak var cancelButtonTaped: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 15
        updateButton.clipsToBounds = true
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
}
