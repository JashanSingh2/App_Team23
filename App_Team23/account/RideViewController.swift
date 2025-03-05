
import UIKit
class RideViewController: UIViewController {
    @IBOutlet weak var homeAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Ride Preferences"
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePreferences))
        saveButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveButton
        loadPreferences()
        setupTextFieldIcons()
        setupTapGesture()
        
        navigationController?.navigationBar.backgroundColor = .clear
    }
    private func loadPreferences() {
            let defaults = UserDefaults.standard
            homeAddressTextField.text = defaults.string(forKey: "homeAddress")
            destinationAddressTextField.text = defaults.string(forKey: "destinationAddress")
            if let savedStartTime = defaults.object(forKey: "startTime") as? Date {
                startTimePicker.date = savedStartTime
            }
            if let savedEndTime = defaults.object(forKey: "endTime") as? Date {
                endTimePicker.date = savedEndTime
            }
        }
    private func setupTextFieldIcons() {
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
            UserDefaults.standard.set(address, forKey: "homeAddress")
        }
    }
    @objc func selectDestinationAddressFromMap() {
        openMap { [weak self] address in
            self?.destinationAddressTextField.text = address
            UserDefaults.standard.set(address, forKey: "destinationAddress")
        }
    }

    func openMap(completion: @escaping (String) -> Void) {
        let mapVC = MKMapViewController()
        mapVC.completionHandler = completion
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func clearHomeAddress(_ sender: UIButton) {
        homeAddressTextField.becomeFirstResponder()
    }
    @IBAction func editDestinationAddress(_ sender: UIButton) {
        destinationAddressTextField.becomeFirstResponder()
    }
    @objc func savePreferences() {
            let homeAddress = homeAddressTextField.text ?? ""
            let destinationAddress = destinationAddressTextField.text ?? ""
            let selectedStartTime = startTimePicker.date
            let selectedEndTime = endTimePicker.date

            if homeAddress.isEmpty || destinationAddress.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Please fill in all the fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                // Save preferences to UserDefaults
                let defaults = UserDefaults.standard
                defaults.set(homeAddress, forKey: "homeAddress")
                defaults.set(destinationAddress, forKey: "destinationAddress")
                defaults.set(selectedStartTime, forKey: "startTime")
                defaults.set(selectedEndTime, forKey: "endTime")

                let alert = UIAlertController(title: "Preferences Saved", message: "Your preferences have been saved successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
