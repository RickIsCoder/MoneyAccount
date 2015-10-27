//
//  Amount+CoreDataProperties.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/27.
//  Copyright © 2015年 Rick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Amount {

    @NSManaged var date: NSDate?
    @NSManaged var day: String?
    @NSManaged var amountDescription: String?
    @NSManaged var id: NSNumber?
    @NSManaged var amount: NSNumber?
    @NSManaged var amountType: AmountType?

}
