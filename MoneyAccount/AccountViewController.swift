//
//  AccountViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/15.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var homepageBgUIView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentDay: String!
    var moneyAccounts: [MoneyAccount]! = []
    var coreDataStack: CoreDataStack!
    
    let SelectedTableViewCellHeight: CGFloat = 90
    let UnSelectedTableViewCellHeight: CGFloat = 45
    var selectedCellIndexPath: NSIndexPath?
    
    @IBOutlet weak var currentDayPaymentCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
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
        accountFetch.predicate = NSPredicate(format: "accountDay == %@", currentDay)
        
        let asyncFetchRequest: NSAsynchronousFetchRequest! = NSAsynchronousFetchRequest(fetchRequest: accountFetch) {
            [unowned self]
            (result: NSAsynchronousFetchResult!) -> Void in
            self.moneyAccounts = result.finalResult as! [MoneyAccount]
            self.tableView.reloadData()
            
            var sumPayment:Float = 0
            for item in self.moneyAccounts {
                sumPayment = Float(item.payment!) + sumPayment
            }
            self.currentDayPaymentCount.text = "\(sumPayment)"
        }
        do {
            try coreDataStack.context.executeRequest(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)", terminator: "")
        }
    }
    
    private func setBgImageForView() {
        let bgColor: UIColor = UIColor(patternImage: UIImage(named: "BGImage")!)
        homepageBgUIView.backgroundColor = bgColor
        tableView.backgroundColor = bgColor
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ConstantsData.SegueNames.addNewAccountVCSegue {
            if let addNewAccountVCon = segue.destinationViewController as? AddNewAccountViewController {
                addNewAccountVCon.coreDataStack = coreDataStack
            }
        }
    }
    
    // MARK: - table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ConstantsData.Identifiers.accountTableViewCell)! as! AccountTablevViewCell
        cell.paymentAccount.text = "\(moneyAccounts[indexPath.row].payment!)"
        if moneyAccounts[indexPath.row].paymentType != nil {
            cell.paymentTypeName.text = "\(moneyAccounts[indexPath.row].paymentType!.typeName!)"
            cell.paymentTypeIcon.image = UIImage(named: moneyAccounts[indexPath.row].paymentType!.typeIconName!)
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyAccounts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedCellIndexPath != nil {
            if selectedCellIndexPath == indexPath {
                return SelectedTableViewCellHeight
            }
        }
        return UnSelectedTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCellIndexPath = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - ScrollView
    private func resizeScrollView() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
        self.scrollView.contentOffset.x = CGFloat(-self.scrollView.frame.size.width)
    }
   
}
