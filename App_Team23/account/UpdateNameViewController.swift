


import UIKit

class UpdateNameViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    var firstName: String?
    var lastName: String?
    var onUpdateName: ((String, String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Name"
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        addCloseButton()
    }
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            // Send a notification with the updated name
            NotificationCenter.default.post(name: Notification.Name("NameUpdated"), object: nil, userInfo: ["firstName": firstName, "lastName": lastName])
            onUpdateName?(firstName, lastName)
        }
        let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
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

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

