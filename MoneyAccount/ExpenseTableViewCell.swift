//
//  ExpenseTableViewCell.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/19.
//  Copyright © 2015年 Rick. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentTypeName: UILabel!
    @IBOutlet weak var paymentAccount: UILabel!
    @IBOutlet weak var paymentTypeIcon: UIImageView!
    @IBOutlet weak var paymentDetial: UILabel!

    var hasDetail: Bool = false
    var detailOnShow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
