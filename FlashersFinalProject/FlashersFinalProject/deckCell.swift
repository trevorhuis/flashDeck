//
//  deckCell.swift
//  FlashersFinalProject
//
//  Created by Trevor on 4/22/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit

class deckCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet weak var deckName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.layer.shadowOpacity = 1
        cellView.layer.shadowOffset = CGSize.zero
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
