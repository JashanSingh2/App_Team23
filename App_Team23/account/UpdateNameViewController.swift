//
//  UpdateNameViewController.swift
//  AccountSection
//
//  Created by Anand Pratap Singh on 18/01/25.
//

//import UIKit
//
//class UpdateNameViewController: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    
//    var onUpdateName: ((String, String) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    }
//
//    @IBAction func updateButtonTapped(_ sender: UIButton) {
//        // Pass the entered names back to the previous view controller
//        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
//            onUpdateName?(firstName, lastName)
//        }
//        navigationController?.popViewController(animated: true)
//    }
//}
//

//import UIKit

//class UpdateNameViewController: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    
//    var onUpdateName: ((String, String) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Optional: Set the title of the screen
//        title = "Update Name"
//    }
//
//    @IBAction func updateButtonTapped(_ sender: UIButton) {
//        // Pass the entered names back to the previous view controller
//        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
//            onUpdateName?(firstName, lastName)
//        }
//        
//        // Pop the view controller to return to the profile screen
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//

//import UIKit
//
//class UpdateNameViewController: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    
//    // Variables to hold the first name and last name passed from ProfileViewController
//    var firstName: String?
//    var lastName: String?
//
//    var onUpdateName: ((String, String) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set the title of the screen
//        title = "Update Name"
//        
//        // Set the text fields with the passed values once the view has loaded
//        firstNameTextField.text = firstName
//        lastNameTextField.text = lastName
//    }
//
//    @IBAction func updateButtonTapped(_ sender: UIButton) {
//        // Pass the entered names back to the previous view controller
//        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
//            onUpdateName?(firstName, lastName)
//        }
//        
//        // Pop the view controller to return to the profile screen
//        navigationController?.popViewController(animated: true)
//    }
//}

//import UIKit
//
//class UpdateNameViewController: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    
//    // Variables to hold the first name and last name passed from ProfileViewController
//    var firstName: String?
//    var lastName: String?
//
//    var onUpdateName: ((String, String) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set the title of the screen
//        title = "Update Name"
//        
//        // Set the text fields with the passed values once the view has loaded
//        firstNameTextField.text = firstName
//        lastNameTextField.text = lastName
//    }
//
//    @IBAction func updateButtonTapped(_ sender: UIButton) {
//        // Pass the entered names back to the previous view controller
//        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
//            onUpdateName?(firstName, lastName)
//        }
//        
//        // Show an alert to confirm that the profile has been updated
//        let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated successfully!", preferredStyle: .alert)
//        
//        // Add an action for the OK button to dismiss the alert and pop the view controller
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            // Pop the view controller after the user taps "OK"
//            self.navigationController?.popViewController(animated: true)
//        }))
//
//        // Present the alert
//        present(alert, animated: true, completion: nil)
//    }
//}

//import UIKit
//
//class UpdateNameViewController: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//
//    var firstName: String?
//    var lastName: String?
//
//    var onUpdateName: ((String, String) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Update Name"
//        firstNameTextField.text = firstName
//        lastNameTextField.text = lastName
//        addCloseButton()
//    }
//
//    @IBAction func updateButtonTapped(_ sender: UIButton) {
//        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
//            onUpdateName?(firstName, lastName)
//        }
//
//        // Show an alert to confirm the update
//        let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated successfully!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            self.navigationController?.popViewController(animated: true)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    // Add close button to the view with a circle
//    func addCloseButton() {
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("X", for: .normal)  // The close symbol
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15) // Adjust font size to fit in circle
//
//        // Set button frame
//        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
//
//        // Set button background color and make it circular
//        closeButton.backgroundColor = .gray // Change the color as needed
//        closeButton.layer.cornerRadius = closeButton.frame.height / 2
//        closeButton.clipsToBounds = true
//
//        // Set button title color
//        closeButton.setTitleColor(.white, for: .normal)
//
//        // Add action for close button
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//
//        // Add button to view
//        self.view.addSubview(closeButton)
//    }
//
//    // Close button action
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil) // Dismiss the view controller
//    }
//
//}
//
//


import UIKit

class UpdateNameViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    var firstName: String?
    var lastName: String?
    var onUpdateName: ((String, String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Name"
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        addCloseButton()
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            // Send a notification with the updated name
            NotificationCenter.default.post(name: Notification.Name("NameUpdated"), object: nil, userInfo: ["firstName": firstName, "lastName": lastName])
            onUpdateName?(firstName, lastName)
            
            
        }

        // Show an alert to confirm the update
        let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
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

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

