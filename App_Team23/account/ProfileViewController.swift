//
//  ProfileViewController.swift
//  AccountSection
//
//  Created by Anand Pratap Singh on 16/01/25.
//

//import UIKit
//
//class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var profileTableView: UITableView!
//
//    let profileInfo = [
//        ("Image", "profileImage"),
//        ("Name", "John Doe"),
//        ("Mobile", "+1234567890"),
//        ("Email", "john.doe@example.com"),
//        ("Pin Code", "123456")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "Profile"
//        
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
//        
//        profileTableView.reloadData()
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileInfo.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if profileInfo[indexPath.row].0 == "Image" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            
//            let item = profileInfo[indexPath.row]
//            
//            // Set the image or a default image if not found
//            if let image = UIImage(named: item.1) {
//                cell.customImageView.image = image
//            } else {
//                if let defaultImage = UIImage(named: "defaultProfileImage") {
//                    cell.customImageView.image = defaultImage
//                } else {
//                    cell.customImageView.image = UIImage(systemName: "person.circle") // System placeholder
//                }
//            }
//            
//            // Adjust the image size and center it (if not done in storyboard)
//            cell.customImageView.contentMode = .scaleAspectFit
//            cell.customImageView.clipsToBounds = true
//            
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            let item = profileInfo[indexPath.row]
//            cell.textLabel?.text = "\(item.0): \(item.1)"
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if profileInfo[indexPath.row].0 == "Image" {
//            return 150.0 // Height for profile image cell
//        }
//        return 44.0 // Default height for other cells
//    }
//}
//
//

//
//import UIKit
//
//class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var profileTableView: UITableView!
//
//    var profileInfo = [
//        ("Image", "profileImage"),
//        ("First Name", "John"),
//        ("Last Name", "Doe"),
//        ("Mobile", "+1234567890"),
//        ("Email", "john.doe@example.com"),
//        ("Pin Code", "123456")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Profile"
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
//    }
//
//    // Table View Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileInfo.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if profileInfo[indexPath.row].0 == "Image" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            
//            let item = profileInfo[indexPath.row]
//            
//            // Set the image or a default image
//            if let image = UIImage(named: item.1) {
//                cell.customImageView.image = image
//            } else {
//                cell.customImageView.image = UIImage(systemName: "person.circle")
//            }
//            
//            cell.customImageView.contentMode = .scaleAspectFit
//            cell.customImageView.clipsToBounds = true
//            
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            let item = profileInfo[indexPath.row]
//            cell.textLabel?.text = "\(item.0): \(item.1)"
//            
//            // Show the chevron for each row
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }
//    }
//
//    // Table View Delegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if profileInfo[indexPath.row].0 == "Image" {
//            return 150.0
//        }
//        return 44.0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        // Trigger the segue to update name for first or last name
//        if indexPath.row == 1 || indexPath.row == 2 {
//            performSegue(withIdentifier: "UpdateNameSegue", sender: self)
//        }
//    }
//
//    // Prepare for the segue and pass data to UpdateNameViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UpdateNameSegue" {
//            if let destinationVC = segue.destination as? UpdateNameViewController {
//                // Pass the firstName and lastName to the UpdateNameViewController
//                destinationVC.firstName = profileInfo[1].1
//                destinationVC.lastName = profileInfo[2].1
//                
//                // Closure to update names
//                destinationVC.onUpdateName = { [weak self] updatedFirstName, updatedLastName in
//                    guard let self = self else { return }
//                    
//                    // Safely update the first name and last name in profileInfo
//                    if self.profileInfo.indices.contains(1) && self.profileInfo.indices.contains(2) {
//                        self.profileInfo[1].1 = updatedFirstName
//                        self.profileInfo[2].1 = updatedLastName
//                    } else {
//                        print("Invalid indices for updating names")
//                    }
//                    
//                    self.profileTableView.reloadData()
//                }
//            }
//        }
//    }
//}
//import UIKit
//
//class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var profileTableView: UITableView!
//
//    var profileInfo = [
//        ("Image", "profileImage"),
//        ("First Name", "John"),
//        ("Last Name", "Doe"),
//        ("Mobile", "+1234567890"),
//        ("Email", "john.doe@example.com"),
//        ("Pin Code", "123456")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Profile"
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
//
//        // Load the updated first name and last name from UserDefaults (if available)
//        let savedFirstName = UserDefaults.standard.string(forKey: "firstName") ?? profileInfo[1].1
//        let savedLastName = UserDefaults.standard.string(forKey: "lastName") ?? profileInfo[2].1
//        profileInfo[1].1 = savedFirstName
//        profileInfo[2].1 = savedLastName
//        
//    }
//
//    // Table View Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileInfo.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if profileInfo[indexPath.row].0 == "Image" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            let item = profileInfo[indexPath.row]
//
//            if let image = UIImage(named: item.1) {
//                cell.customImageView.image = image
//            } else {
//                cell.customImageView.image = UIImage(systemName: "person.circle")
//            }
//            cell.customImageView.contentMode = .scaleAspectFit
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            let item = profileInfo[indexPath.row]
//            cell.textLabel?.text = "\(item.0): \(item.1)"
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 1 || indexPath.row == 2 {
//            performSegue(withIdentifier: "UpdateNameSegue", sender: self)
//        }
//    }
//
//    // Prepare for the segue and pass data to UpdateNameViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UpdateNameSegue" {
//            if let destinationVC = segue.destination as? UpdateNameViewController {
//                // Pass the first name and last name to the UpdateNameViewController
//                destinationVC.firstName = profileInfo[1].1
//                destinationVC.lastName = profileInfo[2].1
//
//                // Closure to update names
//                destinationVC.onUpdateName = { [weak self] updatedFirstName, updatedLastName in
//                    guard let self = self else { return }
//
//                    // Update first name and last name
//                    self.profileInfo[1].1 = updatedFirstName
//                    self.profileInfo[2].1 = updatedLastName
//
//                    // Save the updated names to UserDefaults
//                    UserDefaults.standard.set(updatedFirstName, forKey: "firstName")
//                    UserDefaults.standard.set(updatedLastName, forKey: "lastName")
//
//                    // Reload the table view with the updated names
//                    self.profileTableView.reloadData()
//                }
//            }
//        }
//    }
//}

//import UIKit
//
//class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var profileTableView: UITableView!
//
//    var profileInfo = [
//        ("Image", "profileImage"),
//        ("First Name", "John"),
//        ("Last Name", "Doe"),
//        ("Mobile", "+1234567890"),
//        ("Email", "john.doe@example.com"),
//        ("Pin Code", "123456")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Profile"
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
//
//        // Load the updated first name and last name from UserDefaults (if available)
//        let savedFirstName = UserDefaults.standard.string(forKey: "firstName") ?? profileInfo[1].1
//        let savedLastName = UserDefaults.standard.string(forKey: "lastName") ?? profileInfo[2].1
//        profileInfo[1].1 = savedFirstName
//        profileInfo[2].1 = savedLastName
//    }
//
//    // Table View Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileInfo.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if profileInfo[indexPath.row].0 == "Image" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            let item = profileInfo[indexPath.row]
//
//            if let image = UIImage(named: item.1) {
//                cell.customImageView.image = image
//            } else {
//                cell.customImageView.image = UIImage(systemName: "person.circle")
//            }
//
//            // Set the content mode to maintain aspect ratio
//            cell.customImageView.contentMode = .scaleAspectFit
//
//            // Return the image cell
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            let item = profileInfo[indexPath.row]
//            cell.textLabel?.text = "\(item.0): \(item.1)"
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }
//    }
//
//    // Table View Delegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if profileInfo[indexPath.row].0 == "Image" {
//            return 150.0 // Set the height to match the previous code
//        }
//        return 44.0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 1 || indexPath.row == 2 {
//            performSegue(withIdentifier: "UpdateNameSegue", sender: self)
//        }
//    }
//
//    // Prepare for the segue and pass data to UpdateNameViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UpdateNameSegue" {
//            if let destinationVC = segue.destination as? UpdateNameViewController {
//                // Pass the first name and last name to the UpdateNameViewController
//                destinationVC.firstName = profileInfo[1].1
//                destinationVC.lastName = profileInfo[2].1
//
//                // Closure to update names
//                destinationVC.onUpdateName = { [weak self] updatedFirstName, updatedLastName in
//                    guard let self = self else { return }
//
//                    // Update first name and last name
//                    self.profileInfo[1].1 = updatedFirstName
//                    self.profileInfo[2].1 = updatedLastName
//
//                    // Save the updated names to UserDefaults
//                    UserDefaults.standard.set(updatedFirstName, forKey: "firstName")
//                    UserDefaults.standard.set(updatedLastName, forKey: "lastName")
//
//                    // Reload the table view with the updated names
//                    self.profileTableView.reloadData()
//                }
//            }
//        }
//    }
//}
//



//
//import UIKit
//
//class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var profileTableView: UITableView!
//
//    var profileInfo = [
//        ("Image", "profileImage"),
//        ("First Name", "John"),
//        ("Last Name", "Doe"),
//        ("Mobile", "+1234567890"),
//        ("Email", "john.doe@example.com")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Profile"
//        profileTableView.delegate = self
//        profileTableView.dataSource = self
//
//        // Load updated first name and last name from UserDefaults
//        let savedFirstName = UserDefaults.standard.string(forKey: "firstName") ?? profileInfo[1].1
//        let savedLastName = UserDefaults.standard.string(forKey: "lastName") ?? profileInfo[2].1
//        profileInfo[1].1 = savedFirstName
//        profileInfo[2].1 = savedLastName
//
//        // Add custom close button to the top-right corner
//        addCloseButton()
//    }
//
//    // Add close button to the view with a circle
//    func addCloseButton() {
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("X", for: .normal)  // The close symbol
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15) // Adjust font size to fit in circle
//
//        // Set button frame
//        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
//
//        // Set button background color and make it circular
//        closeButton.backgroundColor = .gray // Change the color as needed
//        closeButton.layer.cornerRadius = closeButton.frame.height / 2
//        closeButton.clipsToBounds = true
//
//        // Set button title color
//        closeButton.setTitleColor(.white, for: .normal)
//
//        // Add action for close button
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//
//        // Add button to view
//        self.view.addSubview(closeButton)
//    }
//
//    // Close button action
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil) // Dismiss the view controller
//    }
//
//    // MARK: Table View Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profileInfo.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if profileInfo[indexPath.row].0 == "Image" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            let item = profileInfo[indexPath.row]
//
//            if let image = UIImage(named: item.1) {
//                cell.customImageView.image = image
//            } else {
//                cell.customImageView.image = UIImage(systemName: "person.circle")
//            }
//
//            cell.customImageView.contentMode = .scaleAspectFit
//
//            // No pencil icon for the "Image" cell
//            cell.accessoryView = nil
//
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
//            let item = profileInfo[indexPath.row]
//            cell.textLabel?.text = "\(item.0): \(item.1)"
//
//            // Add pencil icon for all other cells
//            let pencilImageView = UIImageView(image: UIImage(systemName: "pencil"))
//            pencilImageView.tintColor = .systemBlue
//            cell.accessoryView = pencilImageView
//
//            return cell
//        }
//    }
//
//    // MARK: Table View Delegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if profileInfo[indexPath.row].0 == "Image" {
//            return 150.0 // Height for the image cell
//        }
//        return 44.0 // Default height for other cells
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 1 || indexPath.row == 2 {
//            performSegue(withIdentifier: "UpdateNameSegue", sender: self)
//        }
//    }
//
//    // Prepare for the segue and pass data to UpdateNameViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UpdateNameSegue" {
//            if let destinationVC = segue.destination as? UpdateNameViewController {
//                destinationVC.firstName = profileInfo[1].1
//                destinationVC.lastName = profileInfo[2].1
//
//                destinationVC.onUpdateName = { [weak self] updatedFirstName, updatedLastName in
//                    guard let self = self else { return }
//                    self.profileInfo[1].1 = updatedFirstName
//                    self.profileInfo[2].1 = updatedLastName
//
//                    // Save to UserDefaults and reload the table view
//                    UserDefaults.standard.set(updatedFirstName, forKey: "firstName")
//                    UserDefaults.standard.set(updatedLastName, forKey: "lastName")
//                    self.profileTableView.reloadData()
//                }
//            }
//        }
//    }
//}



import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!

    var profileInfo = [
        ("Image", "profileImage"),
        ("First Name", "John"),
        ("Last Name", "Doe"),
        ("Mobile", "+1234567890"),
        ("Email", "john.doe@example.com")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .singleLine

        // Load updated values from UserDefaults
        let savedFirstName = UserDefaults.standard.string(forKey: "firstName") ?? profileInfo[1].1
        let savedLastName = UserDefaults.standard.string(forKey: "lastName") ?? profileInfo[2].1
        let savedMobile = UserDefaults.standard.string(forKey: "mobile") ?? profileInfo[3].1
        let savedEmail = UserDefaults.standard.string(forKey: "email") ?? profileInfo[4].1

        profileInfo[1].1 = savedFirstName
        profileInfo[2].1 = savedLastName
        profileInfo[3].1 = savedMobile
        profileInfo[4].1 = savedEmail

        // Add the close button
        addCloseButton()
    }

    // Add close button to the view with a circle
    func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        // Set button frame
        closeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
        
        // Set button background color and make it circular
        closeButton.backgroundColor = .gray
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.clipsToBounds = true
        
        // Set button title color
        closeButton.setTitleColor(.white, for: .normal)
        
        // Add action for close button
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Add button to view
        self.view.addSubview(closeButton)
    }

    // Close button action
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Four sections: Profile Image, Name, Mobile, Email
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has only one row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Profile Image
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            if let image = UIImage(named: profileInfo[0].1) {
                cell.customImageView.image = image
            } else {
                cell.customImageView.image = UIImage(systemName: "person.circle")
            }
            cell.customImageView.contentMode = .scaleAspectFit
            return cell
        case 1: // Name (First Name + Last Name)
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
            let fullName = "\(profileInfo[1].1) \(profileInfo[2].1)"
            cell.textLabel?.text = "Name: \(fullName)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        case 2: // Mobile Number
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileCell", for: indexPath)
            cell.textLabel?.text = "\(profileInfo[3].0): \(profileInfo[3].1)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        case 3: // Email Address
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath)
            cell.textLabel?.text = "\(profileInfo[4].0): \(profileInfo[4].1)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        default:
            return UITableViewCell() // Fallback
        }
    }

    // Create a pencil icon for accessory view
    func createPencilAccessoryView() -> UIImageView {
        let pencilImageView = UIImageView(image: UIImage(systemName: "pencil"))
        pencilImageView.tintColor = .systemBlue
        return pencilImageView
    }

    // Adjust cell height for Profile Image Cell only
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150.0 : 44.0
    }

    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            performSegue(withIdentifier: "UpdateNameSegue", sender: self)
        case 2:
            performSegue(withIdentifier: "UpdateMobileSegue", sender: self)
        case 3:
            performSegue(withIdentifier: "UpdateEmailSegue", sender: self)
        default:
            break
        }
    }

    // MARK: Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateNameSegue",
           let destinationVC = segue.destination as? UpdateNameViewController {
            destinationVC.firstName = profileInfo[1].1
            destinationVC.lastName = profileInfo[2].1
            destinationVC.onUpdateName = { [weak self] updatedFirstName, updatedLastName in
                guard let self = self else { return }
                self.profileInfo[1].1 = updatedFirstName
                self.profileInfo[2].1 = updatedLastName
                UserDefaults.standard.set(updatedFirstName, forKey: "firstName")
                UserDefaults.standard.set(updatedLastName, forKey: "lastName")
                self.profileTableView.reloadData()
            }
        }
    }
}




