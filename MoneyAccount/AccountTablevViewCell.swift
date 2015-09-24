//
//  AccountTablevViewCell.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/23.
//  Copyright © 2015年 Rick. All rights reserved.
//

import UIKit

class AccountTablevViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var paymentTypeIcon: UIImageView!
    @IBOutlet weak var paymentAccount: UILabel!
    @IBOutlet weak var paymentTypeName: UILabel!

}
