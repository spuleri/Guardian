//
//  ContactsViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit


class ContactsViewController: UIViewController {

    var viewModel: ContactsTableViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    convenience init(viewModel: ContactsTableViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Nav
        styleNavBar()
        
        // Configure
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Remove extra cells at foooter
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        // Configure tableview data
         ContactCell.registerWithTableView(tableView: self.tableView)
        
        self.tableView.rowHeight = ContactCell.height
        self.tableView.estimatedRowHeight = ContactCell.estimatedHeight
        
        self.viewModel.reloadData(tableView: self.tableView)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContactButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            let name = firstTextField.text
            let number = secondTextField.text
            
            
            
            print("Name: \(name), Phone number \(number)")
            
            // Default to conor image
            var imageName = "Conor"
            
            // If name was some one else whom we have an image of, use them though lol
            if (name?.contains("Sergio"))! { imageName = "Sergio" }
            if (name?.contains("Jacob"))! { imageName = "Jacob" }
            if (name?.contains("Conor"))! { imageName = "Conor" }
            if (name?.contains("Tatiana"))! { imageName = "Tatiana" }
            if (name?.contains("Joseph"))! { imageName = "Joseph" }

            
            let newContact = Contact(name: name!, phone: number!, rank: 0, imageName: imageName, isEmergency: false)
            
            UserStore.instance.addContactToUser(contact: newContact)
            
            // Reload usssssss
            self.viewModel.reloadData(tableView: self.tableView)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Phone"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func styleNavBar() {
        // Hide old navbar
        self.navigationController?.navigationBar.isHidden = true
        
        // Extra padding for top
        let extraPaddingBar = UIView.init(frame: CGRect(x: 0, y: 0.0, width: (self.parent?.view.frame.size.width)!, height: 11.0))
        extraPaddingBar.backgroundColor = UIColor.init(colorLiteralRed:0.26, green:0.29, blue:0.35, alpha:1.0)
        
        // Create new one with custom image
        let newNavBar = UINavigationBar.init(frame: CGRect(x: 0, y: 11.0, width: (self.parent?.view.frame.size.width)!, height: 64.0))
        newNavBar.setBackgroundImage(UIImage.init(named: "Nav Bar Contacts"), for: .default)
        newNavBar.tintColor = UIColor.white
        
        
        // Create BarButtonItem with out back icon
        let backItem = UINavigationItem()
        backItem.setHidesBackButton(true, animated: false)
        let backIcon = UIImage.init(named: "Back")
        let backButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(backButtonPressed))
        
        // Set the button as the left bar button itm
        backItem.setLeftBarButton(backButtonItem, animated: false)
        
        // Set items
        newNavBar.setItems([backItem], animated: false)
        
        // Add this custom Navbar as a subview
        self.view.addSubview(newNavBar)
        self.view.addSubview(extraPaddingBar)
    }
    
    func backButtonPressed(_ sender: Any) {
        print("Back button pressed")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    

}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // cute lil hack for space between cells lol
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellAtIndex(tableView: tableView, indexPath: indexPath)
    }
}

extension ContactsViewController: UITableViewDelegate {}

extension ContactsViewController: DragCellDelegate {
    
    // TODO: Make these non static vars???
    // A snapshot of the row user is moving.
    @nonobjc static var snapshot: UIView? = nil
    
    // Initial index path, where gesture begins.
    @nonobjc static var sourceIndexPath: IndexPath? = nil
    
    // https://www.raywenderlich.com/63089/cookbook-moving-table-view-cells-with-a-long-press-gesture
    func detectedLongPress(longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: location)
        

        
        switch state {
        case UIGestureRecognizerState.began:
            if let path = indexPath {
                // Set source index path!!!
                ContactsViewController.sourceIndexPath = path
                
                // Get the cell
                let cell = self.tableView?.cellForRow(at: path)
                
                // Take a snapshot of the selected row using helper method.
                ContactsViewController.snapshot = self.customSnapshotFromView(inputView: cell!)
                
                // Add the snapshot as subview, centered at cell's center...
                var center = cell?.center
                ContactsViewController.snapshot?.center = center!
                ContactsViewController.snapshot?.alpha = 0.0
                self.tableView.addSubview(ContactsViewController.snapshot!)
                

                UIView.animate(withDuration: 0.25, animations: {
                    // Offset for gesture location.
                    center?.y = location.y
                    ContactsViewController.snapshot?.center = center!
                    ContactsViewController.snapshot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    ContactsViewController.snapshot?.alpha = 0.98
                    
                    // Fade out.
                    cell?.alpha = 0.0
                }, completion: {
                    (finished) in
                    cell?.isHidden = true
                })
                
            }
            break
        case UIGestureRecognizerState.changed:
            var center = ContactsViewController.snapshot?.center
            center?.y = location.y
            ContactsViewController.snapshot?.center = center!
            
            // Is destination valid and is it different from source?
            if let path = indexPath {
                
                if nil == ContactsViewController.sourceIndexPath || !(path == ContactsViewController.sourceIndexPath) {
                    // Update data source
                    self.viewModel.exchangeObjectAtIndex(index: path.section, withObjectAtIndex: (ContactsViewController.sourceIndexPath?.section)!)
                    
                    // Swap the actual cells in realtime
                    self.tableView.moveSection(ContactsViewController.sourceIndexPath!.section, toSection: path.section)
                    
                    // Reload data so appropate data swap happens!! >:D
                    let sectionIndex1 = IndexSet(integer: ContactsViewController.sourceIndexPath!.section)
                    let sectionIndex2 = IndexSet(integer: path.section)
                    
//                    self.tableView.reloadSections(sectionIndex1, with: .none) // or fade, right, left, top, bottom, none, middle, automatic
//                    self.tableView.reloadSections(sectionIndex2, with: .none) // or fade, right, left, top, bottom, none, middle, automatic
                    
                    // Update source so it is in sync with UI changes.
                    ContactsViewController.sourceIndexPath = path
                }
                
            }
            break;
        default:
            // Clean up.
            let cell = self.tableView.cellForRow(at: ContactsViewController.sourceIndexPath!)
            cell?.isHidden = false
            cell?.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                ContactsViewController.snapshot?.center = (cell?.center)!
                ContactsViewController.snapshot?.transform = CGAffineTransform.identity
                ContactsViewController.snapshot?.alpha = 0.0
                
                // Undo fade out.
                cell?.alpha = 1.0
                
            }, completion: {
                (finished) in
                ContactsViewController.sourceIndexPath = nil
                ContactsViewController.snapshot?.removeFromSuperview()
                ContactsViewController.snapshot = nil
            })

            break;
        }
    }
    
    // Returns a customized snapshot of a given view.
    func customSnapshotFromView(inputView: UIView) -> UIView {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Create an image view.
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
}
