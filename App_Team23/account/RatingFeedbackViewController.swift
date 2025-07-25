

import UIKit

class RatingFeedbackViewController: UIViewController, UITextViewDelegate {

    // Outlets
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var submitButton: UIButton!

    private var selectedRating = 0
    private let placeholderText = "Write your feedback here..." // Placeholder text
    private var isFormFrozen = false // To track if the form is frozen

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rating & Feedback"
        setupStars()
        setupTextView()
        setupSubmitButton()
    }
    private func setupStars() {
        for (index, button) in starButtons.enumerated() {
            button.tag = index + 1
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tintColor = .black
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 80),
                button.heightAnchor.constraint(equalToConstant: 80)
            ])
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
        }
    }

    @objc private func starTapped(_ sender: UIButton) {
        guard !isFormFrozen else { return } // Prevent updates if the form is frozen
        selectedRating = sender.tag
        updateStars()
    }

    private func updateStars() {
        for (index, button) in starButtons.enumerated() {
            button.setImage(
                UIImage(systemName: index < selectedRating ? "star.fill" : "star"),
                for: .normal
            )
        }
    }

    // Configure TextView
    private func setupTextView() {
        reviewTextView.layer.borderColor = UIColor.black.cgColor
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 20
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        reviewTextView.delegate = self
        reviewTextView.isScrollEnabled = false
        reviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

        // Set initial placeholder text
        reviewTextView.text = placeholderText
        reviewTextView.textColor = UIColor.lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !isFormFrozen else { return } // Prevent editing if the form is frozen
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !isFormFrozen else { return } // Prevent changes if the form is frozen
        adjustTextViewHeight()
        submitButton.isEnabled = textView.text != placeholderText && !textView.text.isEmpty && selectedRating > 0
        submitButton.backgroundColor = submitButton.isEnabled ? .black : .gray
    }

    private func adjustTextViewHeight() {
        let fixedWidth = reviewTextView.frame.size.width
        let newSize = reviewTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        reviewTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = newSize.height
            }
        }
    }

    // Configure Submit Button
    private func setupSubmitButton() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor.gray
        submitButton.layer.cornerRadius = 20
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc private func submitTapped() {
        guard selectedRating > 0, reviewTextView.text != placeholderText, !reviewTextView.text.isEmpty else { return }

        // Handle feedback submission logic here (e.g., send to server)
        print("Rating: \(selectedRating), Review: \(reviewTextView.text!)")

        // Freeze the form
        freezeForm()

        // Show a pop-up message (UIAlertController)
        let alertController = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted.", preferredStyle: .alert)

        // Add an action (OK button) to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        // Present the alert to the user
        present(alertController, animated: true, completion: nil)
    }

    private func freezeForm() {
        isFormFrozen = true // Set the form as frozen

        // Disable all interactive elements
        for button in starButtons {
            button.isEnabled = false
        }
        reviewTextView.isEditable = false
        submitButton.isEnabled = false
        submitButton.backgroundColor = .gray
    }
   
}
