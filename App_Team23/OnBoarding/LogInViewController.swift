//
//  ViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 16/01/25.
//

import UIKit

class loginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var phoneNumber1: UIView!
    
    @IBOutlet var Email: UIView!
    
    @IBOutlet var Apple: UIView!
    
    @IBOutlet var Google: UIView!
    
    
    @IBOutlet var signUpOutlet: UIButton!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self

        phoneNumber1.layer.borderWidth = 1
        phoneNumber1.layer.borderColor = UIColor.systemGray.cgColor
        phoneNumber1.layer.cornerRadius = 8
        let horizontalLine = UIView()
               horizontalLine.backgroundColor = UIColor.gray // Set the color of the line
               horizontalLine.translatesAutoresizingMaskIntoConstraints = false
               
               // Add the line to the main view
               view.addSubview(horizontalLine)
               
               // Set up constraints
               NSLayoutConstraint.activate([
                horizontalLine.centerYAnchor.constraint(equalTo: phoneNumber1.centerYAnchor), // Place it in the middle
                horizontalLine.leadingAnchor.constraint(equalTo: phoneNumber1.leadingAnchor), // Start at the leading edge
                horizontalLine.trailingAnchor.constraint(equalTo: phoneNumber1.trailingAnchor), // End at the trailing edge
                horizontalLine.heightAnchor.constraint(equalToConstant: 1)])
        Email.layer.borderWidth = 1
        Email.layer.borderColor = UIColor.black.cgColor
        Email.layer.cornerRadius = 8
        Apple.layer.borderWidth = 1
        Apple.layer.borderColor = UIColor.black.cgColor
        Apple.layer.cornerRadius = 8
        Google.layer.borderWidth = 1
        Google.layer.borderColor = UIColor.black.cgColor
        Google.layer.cornerRadius = 8
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == phoneNumberTextField {
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                
                // Ensure only digits are entered
                if !allowedCharacters.isSuperset(of: characterSet) {
                    return false
                }

                // Ensure maximum 10 digits
                let currentText = textField.text ?? ""
                let newLength = currentText.count + string.count - range.length
                return newLength <= 10
            }
            return true
        }
    
    
    
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func appleButtonTapped(_ sender: UIButton) {
        
        if let appleURL = URL(string: "https:appleid.apple.com/"){
            UIApplication.shared.open(appleURL)
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        if let googleURL = URL(string: "https://accounts.google..com/"){
            UIApplication.shared.open(googleURL)
        }
    }
    
    
    
}


