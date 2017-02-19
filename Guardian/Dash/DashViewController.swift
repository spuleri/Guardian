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
}

class DashViewController: UIViewController {
    
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: TableViewModel!
    var navDelegate: DashboardNavDelegate!
    
    convenience init(viewModel: TableViewModel, navDelegate: DashboardNavDelegate) {
        self.init()
        
        self.viewModel = viewModel
        self.navDelegate = navDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Nav
        styleNavBar()
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.navigationItem.title = "Guardian"
//        self.edgesForExtendedLayout = []
        
        
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
        
        self.viewModel.reloadData(tableView: self.tableView)
        
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
        
        let titleImageButtonItem = UIBarButtonItem(image: guardianTextImage, style: .plain, target: self, action: nil)
        titleImageButtonItem.isEnabled = false
        titleImageButtonItem.tintColor = UIColor.white
        titleImageButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.disabled)
        titleImageButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.highlighted)

        titleImageButtonItem.setBackgroundImage(guardianTextImage, for: .disabled, barMetrics: .default)
        titleImageButtonItem.setBackgroundImage(guardianTextImage, for: .highlighted, barMetrics: .default)
        
        
        titleItem.setLeftBarButton(titleImageButtonItem, animated: false)
        titleItem.setRightBarButtonItems([settingsButtonItem, contactsButtonItem], animated: false)
        
    
        
        newNavBar.setItems([titleItem], animated: false)
        
        self.view.addSubview(newNavBar)
    }
    
    @IBAction func checkinButtonPressed(_ sender: Any) {
        NetworkManager.sharedInstance.sampleGet()
    }

    func contactsButtonPressed(_ sender: Any) {
        print("pressed contacts button, must present that view")
        navDelegate.goToContacts()
    }
    
    func settingsButtonPressed(_ sender: Any) {
        print("pressed settings button, must present that view")
        navDelegate.goToSettings()
    }
    

}

extension DashViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.count
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
        return viewModel.cellAtIndex(tableView: tableView, indexPath: indexPath)
    }
}

extension DashViewController: UITableViewDelegate {}
