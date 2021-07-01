//
//  ItemCell.swift
//  Homepwner
//
//  Created by 전소영 on 2021/07/01.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        serialNumberLabel.font = caption1Font
    }
}
