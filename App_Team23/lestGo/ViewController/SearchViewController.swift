//
//  SearchViewController.swift
//  App_Team23
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit
import MapKit


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    @IBOutlet weak var suggestionsTableView: UITableView!
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var modalView: UIView!
    
    @IBOutlet weak var modalBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickUpSearchBar: UISearchBar!
    
    @IBOutlet weak var dropOffSearchBar: UISearchBar!
    
    
    @IBOutlet weak var searchRideButton: UIButton!
    
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    
    
    
    
    private var modalFullyOpenHeight: CGFloat {
            return 0
        }
        private var modalPartiallyOpenHeight: CGFloat {
            return view.bounds.height * 0.3
        }
        private var modalHiddenHeight: CGFloat {
            return view.bounds.height * 0.58
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //seatStackvView.layer.cornerRadius = 10
        
        searchRideButton.isEnabled = false
        
        setupModalView()
        setupPanGesture()
        defaultModalPosition()
        
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        
        pickUpSearchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped(_:)), for: .allEvents)
        dropOffSearchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped(_:)), for: .allEvents)
        
        
        
        
        pickUpSearchBar.searchTextField.addTarget(self, action: #selector(pickUpTextFieldChanged(_:)), for: .editingChanged)
        dropOffSearchBar.searchTextField.addTarget(self, action: #selector(pickUpTextFieldChanged(_:)), for: .editingChanged)
        
        
        
        
        
        
    }
    

            func setupModalView() {
                modalBottomConstraint.constant = modalPartiallyOpenHeight // Start in partially open state
                modalView.layer.cornerRadius = 20
                modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                modalView.clipsToBounds = true
    //            scrollView.delegate = self
            }

            // MARK: - Pan Gesture Setup
            func setupPanGesture() {
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                view.addGestureRecognizer(panGesture)
            }

            // MARK: - Gesture Handling
        // MARK: - Gesture Handling
        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            let velocity = gesture.velocity(in: view).y

            switch gesture.state {
            case .changed:
                // Move the modal position based on the pan gesture translation
                if modalBottomConstraint.constant != modalFullyOpenHeight && modalBottomConstraint.constant != modalHiddenHeight {
                    let newOffset = modalBottomConstraint.constant + translation.y
                    modalBottomConstraint.constant = max(modalFullyOpenHeight, min(modalHiddenHeight, newOffset))
                    gesture.setTranslation(.zero, in: view)

                    // Dynamically adjust the tint opacity based on the modal position

                } else if modalBottomConstraint.constant == modalHiddenHeight {
                    // Ensure tint overlay is visible when modal is hidden and moving back up
                    
                }

            case .ended:
                // Snap to the nearest state (Hidden, Default, or Full Screen)
                if modalBottomConstraint.constant == modalFullyOpenHeight {
                    if velocity > 100 || translation.y > 50 {
                        defaultModalPosition()
                    } else {
                        openModal()
                        
                    }
                } else if modalBottomConstraint.constant == modalHiddenHeight {
                    if velocity < -100 || translation.y < -50 {
                        defaultModalPosition()
                    } else {
                        hideModal()
                    }
                } else {
                    if velocity < -100 || translation.y < -50 {
                        openModal()
                    } else if velocity > 100 || translation.y > 50 {
                        hideModal()
                    } else {
                        defaultModalPosition()
                    }
                }
            default:
                break
            }
        }
        


            // MARK: - Modal Positioning
            func openModal() {
                animateModal(to: modalFullyOpenHeight)
                
            }

            func defaultModalPosition() {
                animateModal(to: modalPartiallyOpenHeight)
            }

            func hideModal() {
                animateModal(to: modalHiddenHeight)
            }

            private func animateModal(to offset: CGFloat) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.modalBottomConstraint.constant = offset
                    self.updateCollectionViewTopConstraint(for: offset)
                    self.view.layoutIfNeeded()
                })
            }
        private func updateCollectionViewTopConstraint(for modalPosition: CGFloat) {
            // Get the safe area inset
            _ = view.safeAreaInsets.top
        }
         
    
   
    
    
    //table view setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RidesDataController.shared.numberOfRidesInHistory() < 5 {
            return RidesDataController.shared.numberOfRidesInHistory()
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! rideSearchTableViewCell
        let address = RidesDataController.shared.rideHistoryAddress(At: indexPath.row)
        cell.updateCell(With: address)
        
        return cell
    }
    
    @objc func pickUpTextFieldChanged(_ sender: UITextField){
        
        if !pickUpSearchBar.text!.isEmpty && !dropOffSearchBar.text!.isEmpty {
            searchRideButton.isEnabled = true
        }
        openModal()

    }
    
    @objc func searchBarTapped(_ sender: UITextField){
        
        openModal()
        
    }
    
    @IBAction func searchButtonTapped() {
        print(dateAndTimePicker.date.description)
        
        performSegue(withIdentifier: "SearchToAvailableRides", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? AvailableRidesViewController {
            destVC.numberOfSeats = Int(seatLabel.text!)
        }
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        
        seatLabel.text = "\(Int(sender.value))"
    }
    
    
    
    
    
    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
            

}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if modalBottomConstraint.constant > modalFullyOpenHeight {
            scrollView.contentOffset = .zero
        }
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//            if let scrollView = otherGestureRecognizer.view as? UIScrollView, scrollView == self.scrollView {
//                return scrollView.contentOffset.y <= 0
//            }
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    
    
    
    
    
    
    
    
    
}



