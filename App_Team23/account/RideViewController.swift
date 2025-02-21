
import UIKit
class RideViewController: UIViewController {
    @IBOutlet weak var homeAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Set custom title for the navigation bar
        self.title = "Ride Preferences"
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePreferences))
        saveButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveButton
        loadPreferences()
        setupTextFieldIcons()
    }
    private func loadPreferences() {
        let defaults = UserDefaults.standard
        homeAddressTextField.text = defaults.string(forKey: "homeAddress")
        destinationAddressTextField.text = defaults.string(forKey: "destinationAddress")
    }
    private func setupTextFieldIcons() {
        // Keep icons for address fields
        addIcon(to: homeAddressTextField, icon: "mappin.circle", selector: #selector(selectHomeAddressFromMap))
        addIcon(to: destinationAddressTextField, icon: "mappin.circle", selector: #selector(selectDestinationAddressFromMap))
    }
    private func addIcon(to textField: UITextField, icon: String, selector: Selector) {
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.isUserInteractionEnabled = true
        textField.rightView = imageView
        textField.rightViewMode = .always
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }

    @objc func selectHomeAddressFromMap() {
        openMap { [weak self] address in
            self?.homeAddressTextField.text = address
            // Save the address to UserDefaults
            UserDefaults.standard.set(address, forKey: "homeAddress")
        }
    }

    @objc func selectDestinationAddressFromMap() {
        openMap { [weak self] address in
            self?.destinationAddressTextField.text = address
            // Save the address to UserDefaults
            UserDefaults.standard.set(address, forKey: "destinationAddress")
        }
    }

    func openMap(completion: @escaping (String) -> Void) {
        let mapVC = MKMapViewController()
        mapVC.completionHandler = completion
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // Action to clear the Home Address TextField
    @IBAction func clearHomeAddress(_ sender: UIButton) {
        homeAddressTextField.becomeFirstResponder()
    }
    
    // Action to edit the Destination Address
    @IBAction func editDestinationAddress(_ sender: UIButton) {
        destinationAddressTextField.becomeFirstResponder()
    }

    // Save preferences
    @objc func savePreferences() {
        let homeAddress = homeAddressTextField.text ?? ""
        let destinationAddress = destinationAddressTextField.text ?? ""

        if homeAddress.isEmpty || destinationAddress.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please fill in all the fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Save preferences to UserDefaults
            let defaults = UserDefaults.standard
            defaults.set(homeAddress, forKey: "homeAddress")
            defaults.set(destinationAddress, forKey: "destinationAddress")

            // Show confirmation message
            let alert = UIAlertController(title: "Preferences Saved", message: "Your preferences have been saved successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Optionally pop the view controller
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
