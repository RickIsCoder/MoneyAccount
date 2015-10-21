//
//  DateFomatter.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/21.
//  Copyright © 2015年 Rick. All rights reserved.
//

import Foundation

//MARK: - NSDate
func getStringDateUseFomatter(date: NSDate) -> String {
    let dateFomatter = NSDateFormatter()
    dateFomatter.dateFormat = "yyyy-MM-dd"
    let stringDay = dateFomatter.stringFromDate(date)
    return stringDay
}

