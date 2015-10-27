//
//  ExpenseViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/10/16.
//  Copyright © 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pageIndex: Int!
    var pageDate: NSDate!

    var moneyAmounts: [Amount]! = []
    var coreDataStack: CoreDataStack!
    
    let SelectedTableViewCellHeight: CGFloat = 90
    let UnSelectedTableViewCellHeight: CGFloat = 45
    var selectedCellIndexPath: NSIndexPath?
    var preSelectedCellIndexPath: NSIndexPath?
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var currentDayPaymentCount: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        self.tableView.backgroundColor = UIColor(patternImage: (UIImage(named: "BGImage"))!)
        
        getDataForCurrentPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 异步查找数据
    func getDataForCurrentPage() {
        let accountFetch = NSFetchRequest(entityName: ConstantsData.EntityNames.AmountEntity)
        accountFetch.predicate = NSPredicate(format: "day == %@", getStringDateUseFomatter(pageDate))
        
        let asyncFetchRequest: NSAsynchronousFetchRequest! = NSAsynchronousFetchRequest(fetchRequest: accountFetch) {
            [unowned self]
            (result: NSAsynchronousFetchResult!) -> Void in
            self.moneyAmounts = result.finalResult as! [Amount]
            self.tableView.reloadData()
            
            var sumPayment:Float = 0
            for item in self.moneyAmounts {
                sumPayment = Float(item.amount!) + sumPayment
            }
            self.currentDayPaymentCount.text = "\(sumPayment)"
        }
        do {
            try coreDataStack.context.executeRequest(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)", terminator: "")
        }
    }
    
    
    //MARK: - tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ConstantsData.Identifiers.expenseTableViewCell) as! ExpenseTableViewCell
        cell.paymentAccount.text = "\(moneyAmounts[indexPath.row].amount!)"
        if moneyAmounts[indexPath.row].amountType != nil {
            cell.paymentTypeName.text = "\(moneyAmounts[indexPath.row].amountType!.typeName!)"
            cell.paymentTypeIcon.image = UIImage(named: moneyAmounts[indexPath.row].amountType!.typeIconName!)
        }
        if moneyAmounts[indexPath.row].amountDescription == nil {
            cell.hasDetail = false
        } else {
            cell.hasDetail = true
            cell.paymentDetial.text = moneyAmounts[indexPath.row].amountDescription
        }
        
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyAmounts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedCellIndexPath != nil {
            if selectedCellIndexPath == indexPath {
                if preSelectedCellIndexPath == selectedCellIndexPath {
                    preSelectedCellIndexPath = nil
                    selectedCellIndexPath = nil
                    return UnSelectedTableViewCellHeight
                }
                preSelectedCellIndexPath = selectedCellIndexPath
                selectedCellIndexPath = nil
                return SelectedTableViewCellHeight
            }
        }
        return UnSelectedTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as! ExpenseTableViewCell
        if cell.hasDetail {
            selectedCellIndexPath = indexPath
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }


    //MARK: - Navgation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ConstantsData.SegueNames.addNewAccountVCSegue {
            if let addNewAccountVCon = segue.destinationViewController as? AddNewAccountViewController {
                addNewAccountVCon.coreDataStack = coreDataStack
                addNewAccountVCon.dateForCurrentPage = pageDate
            }
        }
    }
    
    

    
}
