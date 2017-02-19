//
//  EventCell.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell, CellData {

    
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    // MARK: CellData
    static var nibName: String {
        return "EventCell"
    }
    
    static var height: CGFloat {
        return 74.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(event: Event) {
        // TODO: Actually get data from event
        eventTitle.text = "Marriott"
        eventDate.text = "Feb 06"
        eventTime.text = "6:30PM"
        
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        print("options button pressed")
    }
}
