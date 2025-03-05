//
//  SignupTableViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 18/01/25.
//

import UIKit
import Supabase



class SignupTableViewController: UITableViewController, UITextFieldDelegate, MapLocationDelegate {
    var isTimeSlotExpanded = false // Tracks if the Time Slot is expanded
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://nwjlijnbgvmvcowxyxfu.supabase.co")!,
                                         supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53amxpam5iZ3ZtdmNvd3h5eGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNTI1OTgsImV4cCI6MjA1NDkyODU5OH0.Ie59yeseEc8A82gbJ56IVOq17bZOSjEkmzz-8qCPuPo")

  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailVerifyButton: UIButton!
   
    
    @IBOutlet weak var preferredVehicleTextField: UILabel!
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var busButton: UIButton!

    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
   
    @IBOutlet weak var workTimeTextField: UILabel!
    
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet private weak var pickupLocationTextField: UITextField!
    @IBOutlet private weak var dropoffLocationTextField: UITextField!
    
    // Create text fields programmatically if outlets aren't connected
   
    
    private var currentLocationType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find text fields in the table view cells
        if let pickupCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
            pickupLocationTextField = pickupCell.viewWithTag(1) as? UITextField
        }
        
        if let dropoffCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) {
            dropoffLocationTextField = dropoffCell.viewWithTag(2) as? UITextField
        }
        
        workTimeTextField.isUserInteractionEnabled = false
        
        tableView.dataSource = self
        emailTextField.delegate = self
//              confirmPasswordTextField.delegate = self
//              
//              // Disable the verify buttons initially
//              emailVerifyButton.isEnabled = false
//             
//              
//              // Add targets for text field changes
//              emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//              confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        fromTimePicker.datePickerMode = .time
                toTimePicker.datePickerMode = .time
          }
          
          // MARK: - UITextFieldDelegate
//          @objc func textFieldDidChange(_ textField: UITextField) {
//              if textField == emailTextField {
//                  emailVerifyButton.isEnabled = isValidEmail(emailTextField.text ?? "")
//              } else if textField == confirmPasswordTextField {
//                  phoneNumberVerifyButton.isEnabled = isValidPhoneNumber(phoneNumberTextField.text ?? "")
//              }
          //}
          
          // MARK: - Validation Methods
         
    func updateWorkTime() {
        // Get the times from the pickers
        let fromTime = fromTimePicker.date
        let toTime = toTimePicker.date

        // Create a DateFormatter to format the times
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Example format: "9:00 AM"

        // Convert times to strings
        let fromTimeString = formatter.string(from: fromTime)
        let toTimeString = formatter.string(from: toTime)

        // Update the text field
        workTimeTextField.text = "\(fromTimeString) - \(toTimeString)"
        workTimeTextField.textColor = .black
    }

          
          
          
          // MARK: - Button Actions
          @IBAction func emailVerifyButtonTapped(_ sender: UIButton) {
              print("Email verification requested for: \(emailTextField.text ?? "")")
              // Add your email verification logic here
          }
    
    
    @IBAction func fromTimePickerChanged(_ sender: UIDatePicker) {
        updateWorkTime()
    }

    @IBAction func toTimePickerChanged(_ sender: UIDatePicker) {
        updateWorkTime()
    }

    
    @IBAction func carButtonTapped(_ sender: UIButton) {
        preferredVehicleTextField.text = "Car"
        preferredVehicleTextField.textColor = .black
        carButton.isSelected = true
        busButton.isSelected = false
        carButton.backgroundColor = .systemBlue
        carButton.tintColor = .white
        carButton.layer.cornerRadius = 10
        busButton.backgroundColor = .systemGray6
        busButton.tintColor = .label
        imageViewOutlet.image = UIImage(systemName: "car")
        
    }

    @IBAction func busButtonTapped(_ sender: UIButton) {
        preferredVehicleTextField.text = "Bus"
        preferredVehicleTextField.textColor  = .black
        busButton.isSelected = true
        carButton.isSelected = false
        busButton.backgroundColor = .systemBlue
        busButton.tintColor = .white
        busButton.layer.cornerRadius = 10
        carButton.backgroundColor = .systemGray6
        carButton.tintColor = .label
        imageViewOutlet.image = UIImage(systemName: "bus")
    }
          @IBAction func phoneNumberVerifyButtonTapped(_ sender: UIButton) {
              print("Phone number verification requested for: \(confirmPasswordTextField.text ?? "")")
              
          }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == confirmPasswordTextField {
               // Allow only digits (0-9)
               let allowedCharacters = CharacterSet.decimalDigits
               let characterSet = CharacterSet(charactersIn: string)
               if !allowedCharacters.isSuperset(of: characterSet) {
                   return false
               }

               // Limit to 10 digits
               let currentText = textField.text ?? ""
               let newLength = currentText.count + string.count - range.length
               return newLength <= 10
           }
           return true
       }
    
    
    
    func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = confirmPasswordTextField.text, !password.isEmpty else {
            showAlert("Please enter email and password")
            return
        }

        Task {
            do {
                // Step 1: Sign up the user in Supabase Authentication
                let userResponse = try await supabase.auth.signUp(email: email, password: password)

                // Step 2: Prepare additional user details
                guard let fromTimePicker = fromTimePicker else {
                    print("fromTimePicker is nil")
                    return
                }
                let fromTimeString = DateFormatter.localizedString(from: fromTimePicker.date, dateStyle: .none, timeStyle: .short)
                guard let toTimePicker = toTimePicker else {
                    print("toTimePicker is nil")
                    return
                }
                let toTimeString = DateFormatter.localizedString(from: toTimePicker.date, dateStyle: .none, timeStyle: .short)
                let workTime = "\(fromTimeString) - \(toTimeString)"
                let preferredVehicle = preferredVehicleTextField.text ?? ""

                // Step 3: Insert user details in Supabase Database
                let userData = [
                    "id": userResponse.user.id.uuidString,
                    "email": email,
                    "preferred_vehicle": preferredVehicle,
                    "work_time": workTime
                ]

                try await supabase.database.from("users").insert(userData).execute()

                // Step 4: Show success alert and navigate to login
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Signup Successful",
                        message: "Your account has been created successfully. Please login to continue.",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        // Navigate to login screen
                        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                        self?.navigationController?.setViewControllers([loginVC], animated: true)
                    })
                    
                    self.present(alert, animated: true)
                }
            } catch {
                print("❌ Signup failed: \(error.localizedDescription)")
                showAlert("Signup failed: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func pickupLocationButtonTapped(_ sender: UIButton) {
        print("Opening map for pickup location")
        openMapViewController(for: "pickup")
    }
    
    @IBAction func dropoffLocationButtonTapped(_ sender: UIButton) {
        print("Opening map for dropoff location")
        openMapViewController(for: "dropoff")
    }
    
    private func openMapViewController(for type: String) {
        print("Opening map view controller for: \(type)")
        currentLocationType = type
        let mapVC = MapLocationViewController()
        mapVC.delegate = self
        mapVC.modalPresentationStyle = .pageSheet
        mapVC.isModalInPresentation = true
        present(mapVC, animated: true, completion: nil)
    }
    
    // MapLocationDelegate method
    func didSelectLocation(_ location: String) {
        print("Location selected: \(location) for type: \(currentLocationType ?? "unknown")")
        
        if currentLocationType == "pickup" {
            print("Updating pickup location")
            pickupLocationTextField?.text = location
        } else if currentLocationType == "dropoff" {
            print("Updating dropoff location")
            dropoffLocationTextField?.text = location
        }
        
        tableView.reloadData()
        
        // Dismiss the map view controller
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) {
                print("Map view dismissed")
                self.currentLocationType = nil
            }
        }
    }
    
    // Override table view methods to ensure cells are properly configured
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let textField = cell.viewWithTag(1) as? UITextField {
                    pickupLocationTextField = textField
                }
            } else if indexPath.row == 1 {
                if let textField = cell.viewWithTag(2) as? UITextField {
                    dropoffLocationTextField = textField
                }
            }
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
    }
}


    
  
    

