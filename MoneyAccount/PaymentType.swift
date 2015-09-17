//
//  PaymentType.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/16.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import Foundation
import CoreData

class PaymentType: NSManagedObject {

    @NSManaged var typeDescription: String
    @NSManaged var typeIconName: String
    @NSManaged var typeName: String
    @NSManaged var moneyAccount: MoneyAccount

}
