//
//  ViewController.swift
//  Login Page 3
//
//  Created by Aryan Shukla on 16/01/25.
//

import UIKit
import Supabase

class loginViewController: UIViewController, UITextFieldDelegate {
    private let supabaseController = SupabaseDataController2.shared
    
    @IBOutlet private(set) var enterEmailView: UIView!
    @IBOutlet private(set) weak var passwordTextField: UITextField!
    @IBOutlet private(set) weak var emailTextField: UITextField!
    @IBOutlet private(set) var Apple: UIView!
    @IBOutlet private(set) var Google: UIView!
    @IBOutlet private(set) weak var signUpOutlet: UIButton!
    @IBOutlet private(set) weak var loginButton: UIButton!
    
    private var loadingAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.enterEmailView.layer.borderWidth = 1
            self.enterEmailView.layer.borderColor = UIColor.systemGray.cgColor
            self.enterEmailView.layer.cornerRadius = 8
            
            let horizontalLine = UIView()
            horizontalLine.backgroundColor = UIColor.gray
            horizontalLine.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(horizontalLine)
            
            NSLayoutConstraint.activate([
                horizontalLine.centerYAnchor.constraint(equalTo: self.enterEmailView.centerYAnchor),
                horizontalLine.leadingAnchor.constraint(equalTo: self.enterEmailView.leadingAnchor),
                horizontalLine.trailingAnchor.constraint(equalTo: self.enterEmailView.trailingAnchor),
                horizontalLine.heightAnchor.constraint(equalToConstant: 1)
            ])
            
            self.Apple.layer.borderWidth = 1
            self.Apple.layer.borderColor = UIColor.black.cgColor
            self.Apple.layer.cornerRadius = 8
            self.Google.layer.borderWidth = 1
            self.Google.layer.borderColor = UIColor.black.cgColor
            self.Google.layer.cornerRadius = 8
            self.setupPasswordTextField()
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginButton.isEnabled = false
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            loginButton.isEnabled = true
            showAlert("Please enter email and password")
            return
        }
        
        showLoadingIndicator()
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let (user, details) = try await supabaseController.login(email: email, password: password)
                
                guard user.role == "passenger" else {
                    throw NSError(domain: "LoginError", code: 403, userInfo: [NSLocalizedDescriptionKey: "This login is for passengers only"])
                }
                
                print("DEBUG: Successfully logged in as passenger with ID: \(user.id)")
                
                await MainActor.run {
                    hideLoadingIndicator()
                    navigateToHome()
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    print("DEBUG: Login failed: \(error.localizedDescription)")
                    showAlert("Login failed: \(error.localizedDescription)")
                    loginButton.isEnabled = true
                }
            }
        }
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: nil, message: "Logging in...", preferredStyle: .alert)
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
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
            if let signUpVC = storyboard.instantiateViewController(withIdentifier: "IDSignupTableViewController") as? SignupTableViewController {
                self?.navigationController?.pushViewController(signUpVC, animated: true)
            }
        }
    }
    
    func navigateToHome() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
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
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
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
