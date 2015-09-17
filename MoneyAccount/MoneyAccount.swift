//
//  MoneyAccount.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/16.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import Foundation
import CoreData

class MoneyAccount: NSManagedObject {

    @NSManaged var accountDescription: String
    @NSManaged var id: NSNumber
    @NSManaged var payment: NSNumber
    @NSManaged var accountDate: NSDate
    @NSManaged var paymentType: PaymentType

}
