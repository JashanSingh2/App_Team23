//
//  ViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 16/01/25.
//

import UIKit
import Supabase


class loginViewController: UIViewController,UITextFieldDelegate {
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://nwjlijnbgvmvcowxyxfu.supabase.co")!,
                                  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53amxpam5iZ3ZtdmNvd3h5eGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNTI1OTgsImV4cCI6MjA1NDkyODU5OH0.Ie59yeseEc8A82gbJ56IVOq17bZOSjEkmzz-8qCPuPo")
    
    @IBOutlet var enterEmailView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet var Apple: UIView!
    
    @IBOutlet var Google: UIView!
    
    
    @IBOutlet var signUpOutlet: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        enterEmailView.layer.borderWidth = 1
        enterEmailView.layer.borderColor = UIColor.systemGray.cgColor
        enterEmailView.layer.cornerRadius = 8
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor.gray // Set the color of the line
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the line to the main view
        view.addSubview(horizontalLine)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            horizontalLine.centerYAnchor.constraint(equalTo: enterEmailView.centerYAnchor), // Place it in the middle
            horizontalLine.leadingAnchor.constraint(equalTo: enterEmailView.leadingAnchor), // Start at the leading edge
            horizontalLine.trailingAnchor.constraint(equalTo: enterEmailView.trailingAnchor), // End at the trailing edge
            horizontalLine.heightAnchor.constraint(equalToConstant: 1)])
        
        Apple.layer.borderWidth = 1
        Apple.layer.borderColor = UIColor.black.cgColor
        Apple.layer.cornerRadius = 8
        Google.layer.borderWidth = 1
        Google.layer.borderColor = UIColor.black.cgColor
        Google.layer.cornerRadius = 8
        setupPasswordTextField()
    }
    
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Please enter email and password")
            return
        }

        Task {
            do {
                // Step 1: Authenticate user
                let authResponse = try await supabase.auth.signIn(
                    email: email,
                    password: password
                )
                
                let user = authResponse.user
                print(" User authenticated successfully. User ID: \(user.id)")

                // Step 2: Fetch user details from Supabase Database
                let response: PostgrestResponse<[User]> = try await supabase.database
                    .from("users")
                    .select()
                    .eq("email", value: email)
                    .execute()
                
                if let userData = response.value.first {
                    print(" User data from database: \(userData)")
                    navigateToHome()
                } else {
                    // Create user record if it doesn't exist
                    let userData = [
                        "id": user.id.uuidString,
                        "email": email,
                        "preferred_vehicle": "bus",
                        "work_time": "9:00 AM - 5:00 PM"
                    ]
                    
                    try await supabase.database
                        .from("users")
                        .insert(userData)
                        .execute()
                    
                    navigateToHome()
                }
            } catch {
                print("❌ Login failed: \(error.localizedDescription)")
                showAlert("Invalid credentials. Please try again.")
            }
        }
    }


    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "IDSignupTableViewController") as! SignupTableViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    
    func navigateToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
            
            homeVC.modalPresentationStyle = .overFullScreen
            
            if let navigationController = self.navigationController {
                navigationController.present(homeVC, animated: true)
            } else {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let navController = UINavigationController(rootViewController: homeVC)
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    
    func appleButtonTapped(_ sender: UIButton) {
        
        if let appleURL = URL(string: "https:appleid.apple.com/"){
            UIApplication.shared.open(appleURL)
        }
    }
    
    func googleButtonTapped(_ sender: UIButton) {
        if let googleURL = URL(string: "https://accounts.google..com/"){
            UIApplication.shared.open(googleURL)
        }
    }
    private func setupPasswordTextField() {
            let eyeButton = UIButton(type: .system)
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeButton.tintColor = .gray
            eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

            passwordTextField.rightView = eyeButton
            passwordTextField.rightViewMode = .always
            passwordTextField.isSecureTextEntry = true
            passwordTextField.layer.cornerRadius = 16

        }
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
            passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
}
