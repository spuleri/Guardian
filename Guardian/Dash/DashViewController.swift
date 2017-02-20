//
//  DashViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

protocol DashboardNavDelegate {
    func goToContacts()
    func goToSettings()
    func touchIdAuth(isSuccess: @escaping (Bool) -> Void)
}

class DashViewController: UIViewController {
    
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: DashboardTableViewModel!
    var navDelegate: DashboardNavDelegate!
    
    convenience init(viewModel: DashboardTableViewModel, navDelegate: DashboardNavDelegate) {
        self.init()
        
        self.viewModel = viewModel
        self.navDelegate = navDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Nav
        styleNavBar()
        
        // Configure
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Make BG Color
        // lol is it seriously only the IB inspector property that does it......???
//        self.tableView.backgroundView?.backgroundColor = UIColor.clear
//        self.tableView.backgroundView = nil
        
        // Remov eextra cells at foooter
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        // Configure tableview data
        EventCell.registerWithTableView(tableView: self.tableView)
        
        self.tableView.rowHeight = EventCell.height
        self.tableView.estimatedRowHeight = EventCell.estimatedHeight
        
        
        if let user = GIDSignIn.sharedInstance().currentUser {
                print("Current google user is: \(user.profile.name)")
        }
        else {
            print("uh oh. no user currently signed in through google at the dash")
        }
        
        if let user = UserStore.instance.getCurrentUser() {
            print("Current local user is: \(user.name)")
        }
        else {
            print("uh oh. no user currently signed in locally at the dash")
        }
        
        viewModel.reloadData(tableView: self.tableView)
        
        // Setup option button handler
        setOptionButtonHandler()
        
    }
    
    
    // closures as vars: http://stackoverflow.com/questions/24603559/store-a-closure-as-a-variable-in-swift
    // [weak self]: http://stackoverflow.com/questions/24320347/shall-we-always-use-unowned-self-inside-closure-in-swift
    private func setOptionButtonHandler() {
        let optionsClosure: ( (Event)->() )? = { [weak self] event in
            self?.showOptionsActionSheet(event: event)
        }
        
        self.viewModel.tapEventclosure = optionsClosure
    }
    
    private func showOptionsActionSheet(event: Event) {
        let alertController = UIAlertController(title: "Options for \"\(event.title)\"", message: nil, preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Do not prompt me to check in", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        let  deleteButton = UIAlertAction(title: "Delete forever from Guardian", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
            _ = self.viewModel.removeEventByTitle(title: event.title)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleNavBar() {
        
        self.navigationController?.navigationBar.isHidden = true
        let newNavBar = UINavigationBar.init(frame: CGRect(x: 0, y: 0, width: (self.parent?.view.frame.size.width)!, height: 74.0))
        
        
        newNavBar.setBackgroundImage(UIImage.init(named: "Nav Bar"), for: .default)
        newNavBar.tintColor = UIColor.white
        
        
        let newItem = UINavigationItem()
        newItem.setHidesBackButton(true, animated: false)
        
        let titleItem = UINavigationItem()
        titleItem.setHidesBackButton(true, animated: false)
        
        
        let contactsIcon = UIImage.init(named: "Contacts")
        let settingsIcon = UIImage.init(named: "Settings")
        
        let guardianTextImage = UIImage.init(named: "Guardian")
        
        let contactsButtonItem = UIBarButtonItem(image: contactsIcon, style: .plain, target: self, action: #selector(contactsButtonPressed))
        
        let settingsButtonItem = UIBarButtonItem(image: settingsIcon, style: .plain, target: self, action: #selector(settingsButtonPressed))
        
        let titleImageButtonItem = UIBarButtonItem(image: guardianTextImage, style: .plain, target: self, action: #selector(refreshButtonPressed))

        titleItem.setLeftBarButton(titleImageButtonItem, animated: false)
        titleItem.setRightBarButtonItems([settingsButtonItem, contactsButtonItem], animated: false)
        
        newNavBar.setItems([titleItem], animated: false)
        
        self.view.addSubview(newNavBar)
    }
    
    @IBAction func checkinButtonPressed(_ sender: Any) {
//        self.navDelegate.touchIdAuth(isSuccess: { (isAuthed) in
//            print("i just authed on my own telling! \(isAuthed)")
//            self.presentAuthAlert(isAuthed: isAuthed)
//        })

        self.navDelegate.touchIdAuth(isSuccess: {_ in })
        NetworkManager.sharedInstance.sampleGet()
    }
    
    func presentAuthAlert(isAuthed: Bool) {
        var msg = "This is not the correct fingerprint. Please contact the owner."
        if isAuthed {
            msg = "Thanks for checking in and letting your loved ones know that you're safe."
        }
        self.simpleAlert(title: "Check In", message: msg, okAction: nil, cancelAction: nil, completion: nil)
    }

    func contactsButtonPressed(_ sender: Any) {
        print("pressed contacts button, must present that view")
        navDelegate.goToContacts()
    }
    
    func settingsButtonPressed(_ sender: Any) {
        print("pressed settings button, must present that view")
        navDelegate.goToSettings()
    }
    
    func refreshButtonPressed(_ sender: Any) {
        print("pressed Guardian refresh button")
        self.viewModel.reloadData(tableView: self.tableView)
        
    }
    

}

extension DashViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // cute lil hack for space between cells lol
        return 10;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.cellAtIndex(tableView: tableView, indexPath: indexPath)
    }
}

extension DashViewController: UITableViewDelegate {}
