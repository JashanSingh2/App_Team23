
import UIKit
import Supabase
class EmailOTPVerificationViewController: UIViewController {

    @IBOutlet weak var otpTextField: UITextField!
    var email: String!
    var supabaseClient: SupabaseClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        supabaseClient = SupabaseClient(supabaseURL: URL(string: "https://lazbodjuwncbuwovuyfy.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxhemJvZGp1d25jYnV3b3Z1eWZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0NjM2MTcsImV4cCI6MjA1NjAzOTYxN30.xSk0gmzaLWSLDZ7F3o_LhFH5cIyYzrmEnjwIldyDyrg")
        
        // Setup UI for OTP input
        
        setupTapGesture()
    }

    @IBAction func verifyOTP(_ sender: UIButton) {
        guard let otp = otpTextField.text, !otp.isEmpty else {
            print("Please enter the OTP.")
            return
        }

        verifyOTP(otp)
    }

    func verifyOTP(_ otp: String) {
        // In Supabase, you verify the OTP using a specific method (replace with actual verification method if available).
        // Assuming the OTP verification is handled by the auth client.
//        supabaseClient.auth.verifyOTP(token: otp){[weak self] result in
//            switch result {
//            case .success:
//                print("OTP verified successfully.")
//                self?.updateUserEmail()
//            case .failure(let error):
//                print("OTP verification failed: \(error.localizedDescription)")
//            }
//        }
    }

    func updateUserEmail() {
        // Save the email in UserDefaults or update the user profile in Supabase
        UserDefaults.standard.set(email, forKey: "email")
        Task {
            do {
                try await supabaseClient.auth.signIn(email: "abc@test.test", password: "password")
            } catch {
                print(error.localizedDescription)
            }
        }
        // Navigate to ProfileViewController after email update
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        
        // Dismiss keyboard when user taps outside of the text field
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}





