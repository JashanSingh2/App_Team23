
import UIKit
class OTPViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
