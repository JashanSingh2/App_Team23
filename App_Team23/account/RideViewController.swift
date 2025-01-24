//
//  RideViewController.swift
//  AccountSection
//
//  Created by Anand Pratap Singh on 15/01/25.
//


import UIKit

class RideViewController: UIViewController {

    // Outlets for Home and Destination Address TextFields
    @IBOutlet weak var homeAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var workTimingsLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure the navigation bar is visible
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Set custom title for the navigation bar
        self.title = "Ride Preferences"
        
        // Optionally, customize navigation bar appearance
//        self.navigationController?.navigationBar.barTintColor = UIColor.blue
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Add custom Save button to the navigation bar
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePreferences))
        saveButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveButton
        
        // Restore saved preferences from UserDefaults
        let defaults = UserDefaults.standard
        homeAddressTextField.text = defaults.string(forKey: "homeAddress")
        destinationAddressTextField.text = defaults.string(forKey: "destinationAddress")
        workTimingsLabel.text = defaults.string(forKey: "workTimings")
    }

    // Action to clear the Home Address TextField
    @IBAction func clearHomeAddress(_ sender: UIButton) {
//        homeAddressTextField.text = ""
        homeAddressTextField.becomeFirstResponder()
    }

    // Action to edit the Destination Address
    @IBAction func editDestinationAddress(_ sender: UIButton) {
        // Code to edit destination address
        destinationAddressTextField.becomeFirstResponder()
    }

    // Action to edit Work Timings
    @IBAction func editWorkTimings(_ sender: UIButton) {
        // Code to handle work timings edit
//        let alert = UIAlertController(title: "Edit Work Timings", message: "Functionality coming soon!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
        workTimingsLabel.becomeFirstResponder()
    }

  
    @objc func savePreferences() {
        let homeAddress = homeAddressTextField.text ?? ""
        let destinationAddress = destinationAddressTextField.text ?? ""
        let workTimings = workTimingsLabel.text ?? ""

        if homeAddress.isEmpty || destinationAddress.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let defaults = UserDefaults.standard
            defaults.set(homeAddress, forKey: "homeAddress")
            defaults.set(destinationAddress, forKey: "destinationAddress")
            defaults.set(workTimings, forKey: "workTimings")

            let alert = UIAlertController(title: "Preferences Saved", message: "Your ride preferences have been saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Navigate back to the previous view controller
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
