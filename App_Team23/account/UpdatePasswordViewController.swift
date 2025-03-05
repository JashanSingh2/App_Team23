
import UIKit

class UpdatePasswordViewController: UIViewController {
    @IBOutlet weak var cancelButtonTaped: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 15
        updateButton.clipsToBounds = true
        setupTapGesture()
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
    
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
