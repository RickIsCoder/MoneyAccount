//
//  AmountType+CoreDataProperties.swift
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

extension AmountType {

    @NSManaged var typeDescription: String?
    @NSManaged var typeIconName: String?
    @NSManaged var typeName: String?
    @NSManaged var isExpense: NSNumber?
    @NSManaged var amount: NSSet?

}
