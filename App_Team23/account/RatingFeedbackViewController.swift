

import UIKit
class RatingFeedbackViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var submitButton: UIButton!

    private var selectedRating = 0
    private let placeholderText = "Write your feedback here..."
    private var isFormFrozen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rating & Feedback"
        setupStars()
        setupTextView()
        setupSubmitButton()
        
        setupTapGesture()
        navigationController?.navigationBar.backgroundColor = .clear
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
        guard !isFormFrozen else { return }
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
    private func setupTextView() {
        reviewTextView.layer.borderColor = UIColor.black.cgColor
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 20
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        reviewTextView.delegate = self
        reviewTextView.isScrollEnabled = false
        reviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        reviewTextView.text = placeholderText
        reviewTextView.textColor = UIColor.lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !isFormFrozen else { return }
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
        guard !isFormFrozen else { return }
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
        print("Rating: \(selectedRating), Review: \(reviewTextView.text!)")
        freezeForm()
        
        let alertController = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func freezeForm() {
        isFormFrozen = true 
        for button in starButtons {
            button.isEnabled = false
        }
        reviewTextView.isEditable = false
        submitButton.isEnabled = false
        submitButton.backgroundColor = .gray
    }
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
