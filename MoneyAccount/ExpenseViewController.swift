//
//  AccountViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/15.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController, UIPageViewControllerDataSource
{
    @IBOutlet weak var homepageBgUIView: UIView!
    
    var pageViewController: UIPageViewController!
//    @IBOutlet weak var tableView: UITableView! {
//        didSet {
//            tableView.dataSource = self
//            tableView.delegate = self
//        }
//    }
    
    var currentDay: String!
    var moneyAccounts: [MoneyAccount]! = []
    var coreDataStack: CoreDataStack!
    
    let SelectedTableViewCellHeight: CGFloat = 90
    let UnSelectedTableViewCellHeight: CGFloat = 45
    var selectedCellIndexPath: NSIndexPath?
    
    @IBOutlet weak var currentDayPaymentCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ConstantsData.Identifiers.HomePagePVC) as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.createViewControllerAtIndex(0) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 187, self.view.frame.size.width, self.view.frame.size.height - 197)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        currentDay = getCurrentDay(NSDate())
        
        
        
//        setBgImageForView()
//        getDataForCurrentDay()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(ConstantsData.Identifiers.accountTableViewCell)! as! ExpenseTableViewCell
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
    
    
    // MARK: - UIPageViewController
    
    func createViewControllerAtIndex(index: Int) -> ContentViewController {
        if index < 0 || index >= 3 {
            return ContentViewController()
        }
        
        let contentVC: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ConstantsData.Identifiers.ContentVC) as! ContentViewController
        contentVC.pageIndex = index
        
        return contentVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        var index = contentVC.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index--
        
        return createViewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        var index = contentVC.pageIndex as Int
        
        if index == NSNotFound || index == 2 {
            return nil
        }
        
        index++
        
        return createViewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
