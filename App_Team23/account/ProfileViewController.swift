


import UIKit
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileTableView: UITableView!

    var profileInfo = [
        ("Image", "profileImage"),
        ("First Name", "John"),
        ("Last Name", "Doe"),
        ("Mobile", "+1234567890"),
        ("Email", "john.doe@example.com")
    ]
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .singleLine
        loadProfileData()

        addCloseButton()
        
        
    }
    func loadProfileData() {
        let savedFirstName = UserDefaults.standard.string(forKey: "firstName") ?? profileInfo[1].1
        let savedLastName = UserDefaults.standard.string(forKey: "lastName") ?? profileInfo[2].1
        let savedMobile = UserDefaults.standard.string(forKey: "mobile") ?? profileInfo[3].1
        let savedEmail = UserDefaults.standard.string(forKey: "email") ?? profileInfo[4].1
        profileInfo[1].1 = savedFirstName
        profileInfo[2].1 = savedLastName
        profileInfo[3].1 = savedMobile
        profileInfo[4].1 = savedEmail

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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
               let savedImage = UIImage(data: imageData) {
                cell.customImageView.image = savedImage
            } else {
                let defaultImage = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
                cell.customImageView.image = defaultImage
                cell.customImageView.tintColor = .black
            }
            cell.customImageView.contentMode = .scaleAspectFill
            cell.customImageView.layer.cornerRadius = cell.customImageView.frame.size.width / 2
            cell.customImageView.clipsToBounds = true
            cell.customImageView.layer.borderWidth = 1.0
            cell.customImageView.layer.borderColor = UIColor.black.cgColor
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
            let fullName = "\(profileInfo[1].1) \(profileInfo[2].1)"
            cell.textLabel?.text = "Name: \(fullName)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileCell", for: indexPath)
            cell.textLabel?.text = "\(profileInfo[3].0): \(profileInfo[3].1)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath)
            cell.textLabel?.text = "\(profileInfo[4].0): \(profileInfo[4].1)"
            cell.accessoryView = createPencilAccessoryView()
            return cell
        default:
            return UITableViewCell() // Fallback
        }
    }
    func createPencilAccessoryView() -> UIImageView {
        let pencilImageView = UIImageView(image: UIImage(systemName: "pencil"))
        pencilImageView.tintColor = .systemBlue
        return pencilImageView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            if let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageCell {
                cell.customImageView.image = pickedImage
            }
            saveImageToUserDefaults(image: pickedImage)
            if let imageData = pickedImage.jpegData(compressionQuality: 1.0) {
                NotificationCenter.default.post(name: Notification.Name("ProfileImageUpdated"), object: nil, userInfo: ["imageData": imageData])
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func saveImageToUserDefaults(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 130.0 : 44.0
    }
}
