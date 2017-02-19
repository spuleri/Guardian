//
//  ContactCellTableViewCell.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

protocol DragCellDelegate {
    func detectedLongPress(longPress: UILongPressGestureRecognizer)
}

class ContactCell: UITableViewCell, CellData {

    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var defaultBackground: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var delegate: DragCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized))
        
        self.moveButton.addGestureRecognizer(gestureRecognizer)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: CellData
    static var nibName: String {
        return "ContactCell"
    }
    
    static var height: CGFloat {
        return 74.0
    }
    
    func longPressRecognized(_ sender: Any) {
        print("detected long press")
        
        let longPress = sender as! UILongPressGestureRecognizer
        
        if let delegate = self.delegate {
            delegate.detectedLongPress(longPress: longPress)
        }
        
    }

    func configure(contact: Contact) {
        if !contact.isEmergency {
            toggleHideUIElements(hide: false)
            
            contactImage.image = UIImage.init(named: contact.imageName)
            phoneNumber.text = contact.phone
            name.text = contact.name
            rankLabel.text = String(contact.rank)
            
            self.backgroundView = UIImageView.init(image: UIImage.init(named: "Contact Background"))
            self.selectedBackgroundView = UIImageView.init(image: UIImage.init(named: "Contact Background"))
        } else {
            toggleHideUIElements(hide: true)
            
            self.backgroundView = UIImageView.init(image: UIImage.init(named: "Emergency Services"))
//            self.selectedBackgroundView = UIImageView.init(image: UIImage.init(named: "Emergency Services"))
        }
    }
    
    private func toggleHideUIElements(hide: Bool) {
        contactImage.isHidden = hide
        phoneNumber.isHidden = hide
        name.isHidden = hide
        rankLabel.isHidden = hide
        self.defaultBackground.isHidden = hide
        self.moveButton.isHidden = hide
    }
    
    
}
