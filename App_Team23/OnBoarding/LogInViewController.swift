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
                let session = try await supabase.auth.signIn(email: email, password: password)
                
                // Step 2: Ensure authentication session is active
                guard let user = session.user else {
                    showAlert("Authentication failed. Please try again.")
                    return
                }
                
                print("✅ User authenticated successfully. User ID: \(user.id)")
                print("✅ User Email: \(user.email ?? "No email found")")

                // Step 3: Fetch user details from Supabase Database (Optional)
                let userData = try await supabase.database
                    .from("users")
                    .select()
                    .eq("email", value: email)
                    .single()
                    .execute()

                print("✅ User data from database: \(userData)")

                // Step 4: Navigate to Landing Page
                navigateToHome()
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
            let homeVC = storyboard.instantiateViewController(withIdentifier: "LetsGoViewController") as! LetsGoViewController
            
            if let navigationController = self.navigationController {
                navigationController.setViewControllers([homeVC], animated: true)
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
    
    
    
}
