
//import UIKit
//class UpdateEmailViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addCloseButton()
//    }
//    func addCloseButton() {
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("X", for: .normal)
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
//        closeButton.backgroundColor = .gray
//        closeButton.layer.cornerRadius = closeButton.frame.height / 2
//        closeButton.clipsToBounds = true
//        closeButton.setTitleColor(.white, for: .normal)
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//        self.view.addSubview(closeButton)
//    }
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//


import UIKit
import Supabase

class UpdateEmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var supabaseClient: SupabaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
        // Initialize Supabase Client
        supabaseClient = SupabaseClient(
            supabaseURL: URL(string: "https://your-project-url.supabase.co")!,
            supabaseKey: "your-supabase-key"
        )
    }

    @IBAction func submitEmail(_ sender: UIButton) {
        guard let newEmail = emailTextField.text, !newEmail.isEmpty else {
            print("Please enter a valid email.")
            return
        }
        
        sendOTPToEmail(newEmail)
    }

    func sendOTPToEmail(_ newEmail: String) {
        // Send OTP to the new email
//        let attributes = UserAttributes(email: newEmail)
//
//        supabaseClient.auth.update(userAttributes: attributes) { [weak self] result in
//            switch result {
//            case .success:
//                print("OTP sent to \(newEmail)")
//                // Navigate to OTP Verification ViewController
//                self?.navigateToOTPVerification(email: newEmail)
//            case .failure(let error):
//                print("Failed to send OTP: \(error.localizedDescription)")
//            }
//        }
    }

    func navigateToOTPVerification(email: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let otpVC = storyboard.instantiateViewController(withIdentifier: "EmailOTPVerificationViewController") as? EmailOTPVerificationViewController {
            otpVC.email = email
            otpVC.supabaseClient = supabaseClient // Pass the client to the next VC
            navigationController?.pushViewController(otpVC, animated: true)
        }
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
