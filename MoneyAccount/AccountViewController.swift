//
//  AccountViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/15.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController
{
    @IBOutlet weak var homepageBgUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentDay: String!
    var moneyAccount: [MoneyAccount]! = []
    var coreDataStack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDay = getCurrentDay(NSDate())
        
        setBgImageForView()
        
        getDataForCurrentDay()

    }
    
    private func getCurrentDay(date: NSDate) -> String {
        let dateFomatter = NSDateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let currentDay = dateFomatter.stringFromDate(NSDate())
        return currentDay
    }
    
    // 异步查找数据
    private func getDataForCurrentDay() {
        let accountFetch = NSFetchRequest(entityName: ConstantsData.EntityNames.MoneyAccountEntity)
        accountFetch.predicate = NSPredicate(format: "accountDate == %@", currentDay)
        
        var asyncFetchRequest: NSAsynchronousFetchRequest! = NSAsynchronousFetchRequest(fetchRequest: accountFetch) {
            [unowned self]
            (result: NSAsynchronousFetchResult!) -> Void in
            self.moneyAccount = result.finalResult as! [MoneyAccount]
            self.tableView.reloadData()
        }
        var error: NSError?
        let results = coreDataStack.context.executeRequest(asyncFetchRequest, error: &error)
        
        if let persistentStorResults = results {
            // return immediately, cancel here if you want
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    private func setBgImageForView() {
        let bgColor: UIColor = UIColor(patternImage: UIImage(named: "BGImage")!)
        homepageBgUIView.backgroundColor = bgColor
        tableView.backgroundColor = bgColor
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ConstantsData.SegueNames.addNewAccountVCSegue {
            
        }
    }
    
}
