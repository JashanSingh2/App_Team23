//
//  UpdateMobileViewController.swift
//  App_Team23
//
//  Created by Batch- 1 on 22/01/25.
//

//import UIKit
//
//class UpdateMobileViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        addCloseButton()
//        // Do any additional setup after loading the view.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    
//    
//    
//    
//    func addCloseButton() {
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("X", for: .normal)
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
//        closeButton.backgroundColor = .gray
//        closeButton.layer.cornerRadius = closeButton.frame.height / 2
//        closeButton.clipsToBounds = true
//        closeButton.setTitleColor(.white, for: .normal)
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//        self.view.addSubview(closeButton)
//    }
//
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//
//}


import UIKit

class UpdateMobileViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField! // Connect this to the text field in your storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            showAlert(message: "Please enter a valid mobile number.")
            return
        }

        if !isValidMobileNumber(mobileNumber) {
            showAlert(message: "Invalid mobile number format.")
            return
        }

        // Navigate programmatically to OTPViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let otpViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
//            otpViewController.enteredMobileNumber = mobileNumber
//            otpViewController.onMobileVerificationSuccess = { [weak self] verifiedMobile in
//                guard let self = self else { return }
//                self.dismiss(animated: true, completion: nil)
//                NotificationCenter.default.post(name: .mobileNumberUpdated, object: nil, userInfo: ["mobileNumber": verifiedMobile])
//            }
//            self.present(otpViewController, animated: true, completion: nil)
//        }
    }

    func isValidMobileNumber(_ number: String) -> Bool {
        let mobileRegex = "^[0-9]{10}$" // Adjust regex for your use case
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: number)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
}
