//
//  ExpenseViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/15.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    @IBOutlet weak var homepageBgUIView: UIView!
    
    var pageViewController: UIPageViewController! {
        didSet {
            self.pageViewController.dataSource = self
            self.pageViewController.delegate = self
        }
    }
    
    var nextPage: ContentViewController!
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var currentDay: UILabel!
    
    var DateForCurrentShowingPage: NSDate! {
        willSet {
            currentDay.text = getStringDateUseFomatter(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateForCurrentShowingPage = NSDate()
        initUIPageVC()
    }
      
    // MARK: - UIPageViewController
    // init UIPageViewController 
    func initUIPageVC() {
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ConstantsData.Identifiers.HomePagePVC) as! UIPageViewController
        let startVC = self.createViewControllerAtIndex(2, dateForNewContent: DateForCurrentShowingPage) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 187, self.view.frame.size.width, self.view.frame.size.height - 197)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    // set UIPageViewController
    func reSetUIPageVC() {
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        initUIPageVC()
    }
    
    // Create ContentViewController
    func createViewControllerAtIndex(index: Int, dateForNewContent date: NSDate) -> ContentViewController {
        if index < 0 || index >= 5 {
            return ContentViewController()
        }
        
        let contentVC: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ConstantsData.Identifiers.ContentVC) as! ContentViewController
        contentVC.pageIndex = index
        contentVC.pageDate = date
        contentVC.coreDataStack = coreDataStack
    
        return contentVC
    }
    
    // PageViewController DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        var index = contentVC.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index--
        
        let nextDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: DateForCurrentShowingPage, options: NSCalendarOptions(rawValue: 0))
        return createViewControllerAtIndex(index, dateForNewContent: nextDate!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        var index = contentVC.pageIndex as Int
        
        if index == NSNotFound || index == 5 {
            return nil
        }
        
        index++
        
        let nextDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: DateForCurrentShowingPage, options: NSCalendarOptions(rawValue: 0))
        return createViewControllerAtIndex(index, dateForNewContent: nextDate!)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // PageViewController Delegate
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        self.nextPage = pendingViewControllers[0] as! ContentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            DateForCurrentShowingPage = self.nextPage.pageDate
            
            self.nextPage.getDataForCurrentPage()
            
            if self.nextPage.pageIndex == 4 || self.nextPage.pageIndex == 0 {
                reSetUIPageVC()
            }
        }
    }
}
