//
//  ExpenseViewController.swift
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
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var currentDay: UILabel!
    
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
        
        currentDay.text = getCurrentDay(NSDate())
        
        
        
//        setBgImageForView()
//        getDataForCurrentDay()
    }
    
    
    private func getCurrentDay(date: NSDate) -> String {
        let dateFomatter = NSDateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let currentDay = dateFomatter.stringFromDate(NSDate())
        return currentDay
    }
    
    private func setBgImageForView() {
        let bgColor: UIColor = UIColor(patternImage: UIImage(named: "BGImage")!)
//        homepageBgUIView.backgroundColor = bgColor
//        tableView.backgroundColor = bgColor
    }

        
    
    // MARK: - UIPageViewController
    
    func createViewControllerAtIndex(index: Int) -> ContentViewController {
        if index < 0 || index >= 3 {
            return ContentViewController()
        }
        
        let contentVC: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ConstantsData.Identifiers.ContentVC) as! ContentViewController
        contentVC.pageIndex = index
        contentVC.day = currentDay.text
        contentVC.coreDataStack = coreDataStack
        
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
