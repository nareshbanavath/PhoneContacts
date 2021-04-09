//
//  PhoneContactTableViewCell.swift
//  PhoneContacts
//
//  Created by naresh banavath on 06/04/21.
//

import UIKit

class PhoneContactTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLb: UILabel!
  @IBOutlet weak var contactNumLb: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
