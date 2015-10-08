//
//  MoneyAccount+CoreDataProperties.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/8.
//  Copyright © 2015年 Rick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MoneyAccount {

    @NSManaged var accountDate: NSDate?
    @NSManaged var accountDay: String?
    @NSManaged var accountDescription: String?
    @NSManaged var id: NSNumber?
    @NSManaged var payment: NSNumber?
    @NSManaged var paymentType: PaymentType?

}
