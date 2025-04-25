//
//  SignupTableViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 18/01/25.
//

import UIKit
import Supabase

class SignupTableViewController: UITableViewController, UITextFieldDelegate, MapLocationDelegate {
    private let supabaseController = SupabaseDataController2.shared
    private var loadingAlert: UIAlertController?
    private var isTimeSlotExpanded = false
    
    @IBOutlet private(set) weak var emailTextField: UITextField!
    @IBOutlet private(set) weak var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) weak var emailVerifyButton: UIButton!
    @IBOutlet private(set) weak var preferredVehicleTextField: UILabel!
    @IBOutlet private(set) weak var carButton: UIButton!
    @IBOutlet private(set) weak var busButton: UIButton!
    @IBOutlet private(set) weak var fromTimePicker: UIDatePicker!
    @IBOutlet private(set) weak var toTimePicker: UIDatePicker!
    @IBOutlet private(set) weak var workTimeTextField: UILabel!
    @IBOutlet private(set) weak var imageViewOutlet: UIImageView!
    @IBOutlet private(set) weak var pickupLocationTextField: UITextField!
    @IBOutlet private(set) weak var dropoffLocationTextField: UITextField!
    
    private var currentLocationType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.navigationBar.backgroundColor = self.view.backgroundColor
            self.workTimeTextField.isUserInteractionEnabled = false
            self.tableView.dataSource = self
            self.emailTextField.delegate = self
            
            self.fromTimePicker.datePickerMode = .time
            self.toTimePicker.datePickerMode = .time
            
            // Find and setup location text fields
            if let pickupCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
                self.pickupLocationTextField = pickupCell.viewWithTag(1) as? UITextField
            }
            if let dropoffCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) {
                self.dropoffLocationTextField = dropoffCell.viewWithTag(2) as? UITextField
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        // Disable signup button to prevent multiple taps
        sender.isEnabled = false
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = confirmPasswordTextField.text,
              !password.isEmpty,
              let pickupLocation = pickupLocationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !pickupLocation.isEmpty,
              let dropoffLocation = dropoffLocationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !dropoffLocation.isEmpty else {
            sender.isEnabled = true
            showAlert("Please fill in all required fields")
            return
        }
        
        showLoadingIndicator()
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Create passenger details
                let passengerDetails = PassengerDetails2(
                    id: UUID(),
                    name: email.components(separatedBy: "@").first ?? "User",
                    pickupAdd: pickupLocation,
                    pickupTime: fromTimePicker.date,
                    destinationAdd: dropoffLocation,
                    destinationTime: toTimePicker.date,
                    preferredVehicle: preferredVehicleTextField.text?.lowercased() ?? "bus"
                )
                
                // Sign up user with passenger details
                let user = try await supabaseController.signUpPassenger(
                    email: email,
                    password: password,
                    phone: "",  // Phone can be updated later
                    passengerDetails: passengerDetails
                )
                
                // Show success and navigate to login on main thread
                await MainActor.run {
                    hideLoadingIndicator()
                    showSuccessAndNavigate()
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    print("DEBUG: Signup failed: \(error.localizedDescription)")
                    showAlert("Signup failed: \(error.localizedDescription)")
                    sender.isEnabled = true
                }
            }
        }
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: nil, message: "Creating account...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .medium
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            self?.loadingAlert = alert
            self?.present(alert, animated: true)
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingAlert?.dismiss(animated: true)
            self?.loadingAlert = nil
        }
    }
    
    private func showSuccessAndNavigate() {
        let alert = UIAlertController(
            title: "Signup Successful",
            message: "Your passenger account has been created successfully. Please login to continue.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self?.navigationController?.setViewControllers([loginVC], animated: true)
            }
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    // Keep existing UI-related methods with memory safety improvements
    func updateWorkTime() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let fromTimeString = formatter.string(from: self.fromTimePicker.date)
            let toTimeString = formatter.string(from: self.toTimePicker.date)
            self.workTimeTextField.text = "\(fromTimeString) - \(toTimeString)"
            self.workTimeTextField.textColor = .black
        }
    }
    
    @IBAction func fromTimePickerChanged(_ sender: UIDatePicker) {
        updateWorkTime()
    }
    
    @IBAction func toTimePickerChanged(_ sender: UIDatePicker) {
        updateWorkTime()
    }
    
    @IBAction func carButtonTapped(_ sender: UIButton) {
        preferredVehicleTextField.text = "car"
        updateVehicleSelection(isCar: true)
    }
    
    @IBAction func busButtonTapped(_ sender: UIButton) {
        preferredVehicleTextField.text = "bus"
        updateVehicleSelection(isCar: false)
    }
    
    private func updateVehicleSelection(isCar: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.preferredVehicleTextField.textColor = .black
            self.carButton.isSelected = isCar
            self.busButton.isSelected = !isCar
            
            self.carButton.backgroundColor = isCar ? .systemBlue : .systemGray6
            self.carButton.tintColor = isCar ? .white : .label
            self.busButton.backgroundColor = isCar ? .systemGray6 : .systemBlue
            self.busButton.tintColor = isCar ? .label : .white
            
            self.carButton.layer.cornerRadius = 10
            self.busButton.layer.cornerRadius = 10
            
            self.imageViewOutlet.image = UIImage(systemName: isCar ? "car" : "bus")
        }
    }
    
    // Keep existing location-related methods
    @IBAction func pickupLocationButtonTapped(_ sender: UIButton) {
        openMapViewController(for: "pickup")
    }
    
    @IBAction func dropoffLocationButtonTapped(_ sender: UIButton) {
        openMapViewController(for: "dropoff")
    }
    
    private func openMapViewController(for type: String) {
        currentLocationType = type
        let mapVC = MapLocationViewController()
        mapVC.delegate = self
        mapVC.modalPresentationStyle = .pageSheet
        mapVC.isModalInPresentation = true
        present(mapVC, animated: true)
    }
    
    func didSelectLocation(_ location: String) {
        if currentLocationType == "pickup" {
            pickupLocationTextField?.text = location
        } else if currentLocationType == "dropoff" {
            dropoffLocationTextField?.text = location
        }
        
        tableView.reloadData()
        
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.currentLocationType = nil
            }
        }
    }
    
    func showAlert(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    // TableView methods
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


    
  
    

