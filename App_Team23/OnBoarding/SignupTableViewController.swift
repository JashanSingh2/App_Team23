//
//  SignupTableViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 18/01/25.
//

import UIKit
import Supabase



class SignupTableViewController: UITableViewController, UITextFieldDelegate {
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
        
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
              // Add your phone number verification logic here
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
                let fromTimeString = DateFormatter.localizedString(from: fromTimePicker.date, dateStyle: .none, timeStyle: .short)
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

                showAlert("Signup successful! Please verify your email and log in.")

                // Step 4: Navigate to the Login screen
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                showAlert("Signup failed: \(error.localizedDescription)")
            }
        }
    }


    
      }

    // Number of Rows
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Static rows + dynamic rows for Start and End Time
//        return isTimeSlotExpanded ? 8 : 6
//    }
//
//    // Cell Configuration
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Static Cells
//        if indexPath.row < 6 {
//            let cell = super.tableView(tableView, cellForRowAt: indexPath)
//            return cell
//        }
//        // Dynamic Cells for Time Slot
//        else if indexPath.row == 6 {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "StartTimeCell")
//            cell.textLabel?.text = "Select Start Time"
//            cell.textLabel?.textColor = .gray
//            return cell
//        } else if indexPath.row == 7 {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "EndTimeCell")
//            cell.textLabel?.text = "Select End Time"
//            cell.textLabel?.textColor = .gray
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    // Row Selection
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 5 { // Work Timing Cell
//            isTimeSlotExpanded.toggle() // Toggle the state
//            tableView.reloadData() // Reload the table to show/hide Time Slot cells
//        }
//    }
    
    
//    @IBAction func timeslotButtonPressed(_ sender: Any) {
//        
//        isTimeSlotExpanded.toggle()
//        timeslotOutlet.isHidden = !isTimeSlotExpanded
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
    
  
    

