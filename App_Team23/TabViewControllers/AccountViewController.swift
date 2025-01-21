


import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets for table view
    @IBOutlet weak var tableView: UITableView!
    
    // Label to display full name
    @IBOutlet weak var accountNameLabel: UILabel!
    
    var fullName: String? = "John Doe" // Default name
    
    // Define the settings and support arrays
    let settings = ["Ride Preference", "Login & Security", "Rating & Feedback"]
    let support = ["Mail Us"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the initial name in the label
        accountNameLabel.text = fullName
        
        // Add the Log Out button as the footer view
        addLogOutButton()
        
        // Observe notifications for name updates
        NotificationCenter.default.addObserver(self, selector: #selector(updateName(_:)), name: Notification.Name("NameUpdated"), object: nil)
    }
    
    // MARK: - Handle Notifications
    @objc func updateName(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let firstName = userInfo["firstName"] as? String,
           let lastName = userInfo["lastName"] as? String {
            fullName = "\(firstName) \(lastName)"
            accountNameLabel.text = fullName
        }
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: Settings and Support
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settings.count
        } else {
            return support.count
        }
    }
    
    // MARK: - Section Headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "SETTINGS"  // Title for Settings section
        } else {
            return "SUPPORT"   // Title for Support section
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        if indexPath.section == 0 {
            if indexPath.row == 0 { // Ride Preference tapped
                // Navigate to Ride Preference view controller
                let ridePreferenceVC = storyboard?.instantiateViewController(withIdentifier: "RideViewController") as! RideViewController
                self.navigationController?.pushViewController(ridePreferenceVC, animated: true)
            } else if indexPath.row == 1 { // Login & Security tapped
                // Navigate to Login & Security view controller
                let loginSecurityVC = storyboard?.instantiateViewController(withIdentifier: "LoginSecurityViewController") as! LoginSecurityViewController
                self.navigationController?.pushViewController(loginSecurityVC, animated: true)
            } else if indexPath.row == 2 { // Rating & Feedback tapped
                // Navigate to Rating & Feedback view controller
                let ratingFeedbackVC = storyboard?.instantiateViewController(withIdentifier: "RatingFeedbackViewController") as! RatingFeedbackViewController
                self.navigationController?.pushViewController(ratingFeedbackVC, animated: true)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 { // Mail Us tapped
                // Navigate to Mail Us view controller
                let mailUsVC = storyboard?.instantiateViewController(withIdentifier: "MailUsViewController") as! MailUsViewController
                self.navigationController?.pushViewController(mailUsVC, animated: true)
            }
        }
        
      
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        // Configure cell content
        if indexPath.section == 0 {
            cell.textLabel?.text = settings[indexPath.row]
        } else {
            cell.textLabel?.text = support[indexPath.row]
        }
        
        // Add disclosure indicator (chevron right) for each row
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - Log Out Button (Added as Footer)
    func addLogOutButton() {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.backgroundColor = .black
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.layer.cornerRadius = 25
        logOutButton.clipsToBounds = true
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        containerView.addSubview(logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            logOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            logOutButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        tableView.tableFooterView = containerView
    }

    @objc func logOutButtonTapped() {
        print("Log Out button tapped")
        // Implement log out functionality here
    }
}
