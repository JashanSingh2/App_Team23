//
//  SuggestedRidesViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 17/01/25.
//

import UIKit

class SuggestedRidesViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var sectionNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateSectionLabel() {
        testLabel.text = RidesDataController.shared.sectionHeadersInLetsGo(at: sectionNumber)
    }
    
    

}
