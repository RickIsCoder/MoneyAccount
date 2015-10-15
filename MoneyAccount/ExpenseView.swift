//
//  ExpenseView.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/14.
//  Copyright © 2015年 Rick. All rights reserved.
//

import UIKit

class ExpenseView: UIView {

    @IBOutlet var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    
    func loadViewFromNib() {
        NSBundle.mainBundle().loadNibNamed("ExpenseView", owner: self, options: nil)
        self.addSubview(self.innerView)
    }
    
    override func layoutSubviews() {
        self.innerView.frame = self.frame
        self.setNeedsUpdateConstraints()
    }

}
