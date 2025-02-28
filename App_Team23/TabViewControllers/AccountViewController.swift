
import UIKit
class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountNameLabel: UILabel!
    var fullName: String? = "John Doe" // Default name
    
    @IBOutlet weak var profileImageView: UIImageView!
    let settings = ["Ride Preference", "Login & Security", "Rating & Feedback"]
    let support = ["Mail Us"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadSavedName()
        accountNameLabel.text = fullName
        addLogOutButton()
        
        // Observe notifications for name updates
        NotificationCenter.default.addObserver(self, selector: #selector(updateName(_:)), name: Notification.Name("NameUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImage(_:)), name: Notification.Name("ProfileImageUpdated"), object: nil)
           loadSavedName()
           loadSavedProfileImage()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.contentMode = .scaleAspectFill
        // Bell icon
        let bellIcon = UIImage(systemName: "bell")
        let bellBarButtonItem = UIBarButtonItem(image: bellIcon, style: .plain, target: self, action: #selector(bellIconTapped))
        bellBarButtonItem.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = bellBarButtonItem
        
    }
    @objc func bellIconTapped() {
            print("Bell icon tapped!")
        }
    // MARK: - Load Saved Name
    func loadSavedName() {
        if let savedFullName = UserDefaults.standard.string(forKey: "fullName") {
            fullName = savedFullName
        }
    }
    // MARK: - Handle Notifications
    @objc func updateName(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let firstName = userInfo["firstName"] as? String,
           let lastName = userInfo["lastName"] as? String {
            fullName = "\(firstName) \(lastName)"
            accountNameLabel.text = fullName
            UserDefaults.standard.set(fullName, forKey: "fullName")
        }
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settings.count
        } else {
            return support.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "SETTINGS"
        } else {
            return "SUPPORT"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let ridePreferenceVC = storyboard?.instantiateViewController(withIdentifier: "RideViewController") as! RideViewController
                self.navigationController?.pushViewController(ridePreferenceVC, animated: true)
            } else if indexPath.row == 1 {
                let loginSecurityVC = storyboard?.instantiateViewController(withIdentifier: "LoginSecurityViewController") as! LoginSecurityViewController
                self.navigationController?.pushViewController(loginSecurityVC, animated: true)
            } else if indexPath.row == 2 {
                let ratingFeedbackVC = storyboard?.instantiateViewController(withIdentifier: "RatingFeedbackViewController") as! RatingFeedbackViewController
                self.navigationController?.pushViewController(ratingFeedbackVC, animated: true)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let mailUsVC = storyboard?.instantiateViewController(withIdentifier: "MailUsViewController") as! MailUsViewController
                self.navigationController?.pushViewController(mailUsVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        // Configure the text for the cell
        if indexPath.section == 0 {
            cell.textLabel?.text = settings[indexPath.row]
        } else {
            cell.textLabel?.text = support[indexPath.row]
        }
        let iconName: String
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                iconName = "car"
            case 1:
                iconName = "lock.shield"
            case 2:
                iconName = "star"
            default:
                iconName = "gear"
            }
        } else {
            iconName = "envelope"
        }
        cell.imageView?.image = UIImage(systemName: iconName)
        cell.imageView?.tintColor = .black

        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    func addLogOutButton() {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.backgroundColor = .black
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.layer.cornerRadius = 20
        logOutButton.clipsToBounds = true
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        containerView.addSubview(logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 90),
            logOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -90),
            logOutButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        tableView.tableFooterView = containerView
    }
    
    @objc func logOutButtonTapped() {
        print("Log Out button tapped")
    }
    
    @objc func updateProfileImage(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let imageData = userInfo["imageData"] as? Data,
           let updatedImage = UIImage(data: imageData) {
            profileImageView.image = updatedImage
            
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
        }
    }
    func loadSavedProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let savedImage = UIImage(data: imageData) {
            profileImageView.image = savedImage
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
    }

}

