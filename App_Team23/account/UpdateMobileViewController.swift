

import UIKit

class UpdateMobileViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField! // Connect this to the text field in your storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            showAlert(message: "Please enter a valid mobile number.")
            return
        }

        if !isValidMobileNumber(mobileNumber) {
            showAlert(message: "Invalid mobile number format.")
            return
        }

    }

    func isValidMobileNumber(_ number: String) -> Bool {
        let mobileRegex = "^[0-9]{10}$" // Adjust regex for your use case
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: number)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
}
