//
//  UpdateEmailViewController.swift
//  App_Team23
//
//  Created by Batch- 1 on 22/01/25.
//

import UIKit

class UpdateEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
        // Do any additional setup after loading the view.
    }
    
    func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
        closeButton.backgroundColor = .gray
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.clipsToBounds = true
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
