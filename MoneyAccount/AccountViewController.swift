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
//    @IBOutlet weak var tableView: UITableView! {
//        didSet {
//            tableView.dataSource = self
//            tableView.delegate = self
//        }
//    }
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
        
        addExpenseViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        currentDay = getCurrentDay(NSDate())
        
        
        
//        setBgImageForView()
//        getDataForCurrentDay()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        resizeScrollView()
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
//            self.tableView.reloadData()
            
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
//        homepageBgUIView.backgroundColor = bgColor
//        tableView.backgroundColor = bgColor
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
        let cell = tableView.dequeueReusableCellWithIdentifier(ConstantsData.Identifiers.accountTableViewCell)! as! ExpenseTableCell
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
    func initScrollView() {
//        self.scrollView.frame.size.width = CGFloat(320)
        
        
//        addExpenseViews()
    }
    
    func resizeScrollView() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
        self.scrollView.layoutIfNeeded()
        
        
        
        print(self.view.frame.size,"+",self.scrollView.frame.size,"+",self.scrollView.contentSize)
        
        
    }
    
    func addExpenseViews() {
        let preExpenseView = ExpenseView()
        let expenseView = ExpenseView()
        let afterExpenseView = ExpenseView()
        
        expenseView.translatesAutoresizingMaskIntoConstraints = false
        preExpenseView.translatesAutoresizingMaskIntoConstraints = false
        afterExpenseView.translatesAutoresizingMaskIntoConstraints = false
        

        self.scrollView.addSubview(expenseView)
        self.scrollView.addSubview(preExpenseView)
        self.scrollView.addSubview(afterExpenseView)
        
        setExpenseViewConstraints(expenseView)
        setExpenseViewConstraints(preExpenseView)
        setExpenseViewConstraints(afterExpenseView)
        
        expenseView.tableView.backgroundColor = UIColor.grayColor()
        preExpenseView.tableView.backgroundColor = UIColor.greenColor()
        afterExpenseView.tableView.backgroundColor = UIColor.blackColor()
        
        let expenseViewPositionConstraint = NSLayoutConstraint(item: expenseView, attribute: .LeadingMargin, relatedBy: .Equal, toItem: self.scrollView, attribute: .Leading, multiplier: 1, constant: self.scrollView.bounds.width)
        self.scrollView.addConstraint(expenseViewPositionConstraint)
        
        let preExpenseViewPositionConstraint = NSLayoutConstraint(item: preExpenseView, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollView, attribute: .Leading, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(preExpenseViewPositionConstraint)
        
        let afterExpenseViewPositionConstraint = NSLayoutConstraint(item: afterExpenseView, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollView, attribute: .Leading, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(afterExpenseViewPositionConstraint)
        
        
        
        
        
        
        
        
        self.scrollView.layoutIfNeeded()
    }
    
    func setExpenseViewConstraints(expenseView: ExpenseView) {
        let topConstraint = NSLayoutConstraint(item: expenseView, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(topConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: expenseView, attribute: .Height, relatedBy: .Equal, toItem: self.scrollView, attribute: .Height, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(heightConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: expenseView, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(widthConstraint)
    }
   
}
