//
//  SignupTableViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 18/01/25.
//

import UIKit




class SignupTableViewController: UITableViewController, UITextFieldDelegate {
    var isTimeSlotExpanded = false // Tracks if the Time Slot is expanded
  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailVerifyButton: UIButton!
    @IBOutlet weak var phoneNumberVerifyButton: UIButton!
    
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
              phoneNumberTextField.delegate = self
              
              // Disable the verify buttons initially
              emailVerifyButton.isEnabled = false
              phoneNumberVerifyButton.isEnabled = false
              
              // Add targets for text field changes
              emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
              phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        fromTimePicker.datePickerMode = .time
                toTimePicker.datePickerMode = .time
          }
          
          // MARK: - UITextFieldDelegate
          @objc func textFieldDidChange(_ textField: UITextField) {
              if textField == emailTextField {
                  emailVerifyButton.isEnabled = isValidEmail(emailTextField.text ?? "")
              } else if textField == phoneNumberTextField {
                  phoneNumberVerifyButton.isEnabled = isValidPhoneNumber(phoneNumberTextField.text ?? "")
              }
          }
          
          // MARK: - Validation Methods
          func isValidEmail(_ email: String) -> Bool {
              let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
              let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
              return emailPredicate.evaluate(with: email)
          }
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

          
          func isValidPhoneNumber(_ phone: String) -> Bool {
              let phoneRegex = "^[0-9]{10}$" // Adjust the regex for your specific requirements
              let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
              return phonePredicate.evaluate(with: phone)
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
              print("Phone number verification requested for: \(phoneNumberTextField.text ?? "")")
              // Add your phone number verification logic here
          }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == phoneNumberTextField {
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
    
  
    

