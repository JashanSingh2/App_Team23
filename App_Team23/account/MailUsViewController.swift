//
//  MailUsViewController.swift
//  AccountSection
//
//  Created by Batch- 1 on 16/01/25.
//

import UIKit

class MailUsViewController: UIViewController {

    override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Mail Us"
       }
       @IBAction func emailTapped(_ sender: UIButton) {
           if let url = URL(string: "mailto:support@example.com") {
               UIApplication.shared.open(url)
           }
       }

}
