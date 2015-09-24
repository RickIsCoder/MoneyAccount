//
//  AppDelegate.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/14.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 第一次使用应用时，读入默认数据
        preloadCSVData()
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let isPreloaded = defaults.boolForKey("isPreloaded")
//        if !isPreloaded {
//            preloadData()
//            defaults.setBool(true, forKey: "isPreloaded")
//        }
//        
        
        // 将coreDataStack传给viewController
        if let tabBarController: UITabBarController = self.window!.rootViewController! as? UITabBarController {
            if let navVCon = tabBarController.viewControllers![0] as? UINavigationController {
                if let accountViewController = navVCon.visibleViewController as? AccountViewController {
                    accountViewController.coreDataStack = coreDataStack
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
        coreDataStack.saveContext()
    }

//    // MARK: - Core Data stack
//
//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "Rick.MoneyAccount" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1] as! NSURL
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("MoneyAccount", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MoneyAccount.sqlite")
//        var error: NSError? = nil
//        var failureReason = "There was an error creating or loading the application's saved data."
//        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
//        
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        if coordinator == nil {
//            return nil
//        }
//        var managedObjectContext = NSManagedObjectContext()
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        if let moc = self.managedObjectContext {
//            var error: NSError? = nil
//            if moc.hasChanges && !moc.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NSLog("Unresolved error \(error), \(error!.userInfo)")
//                abort()
//            }
//        }
//    }
    
    
    func preloadCSVData() {
        // Retrieve data from the source file
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("paymentDefaultType", withExtension: "csv") {
            
            // Remove all data
            removeAllExitData()
            
            let accountTypeEntity = NSEntityDescription.entityForName(ConstantsData.EntityNames.PaymentTypeEntity, inManagedObjectContext: coreDataStack.context)
            do {
                let items = try parseCSV(contentsOfURL, encoding: NSUTF8StringEncoding)
                // Preload the menu items
                for item in items {
                    let accountType = PaymentType(entity:accountTypeEntity!, insertIntoManagedObjectContext: coreDataStack.context)
                    accountType.typeName = item.typeName
                    accountType.typeIconName = item.typeIconName
                    accountType.typeDescription = item.typeDescription
                    
                    coreDataStack.saveContext()
                }
            } catch let error as NSError {
                print("\(error.userInfo)")
            }
        }
    }
    
    func removeAllExitData() {
        // Remove the existing items
        let fetchRequest = NSFetchRequest(entityName: ConstantsData.EntityNames.PaymentTypeEntity)
        do {
            let items = (try coreDataStack.context.executeFetchRequest(fetchRequest)) as! [PaymentType]
            for item in items {
                coreDataStack.context.deleteObject(item)
            }
        } catch let error as NSError {
            print("Failed to retrieve record: \(error.localizedDescription)")
        }
    }
    
    

}

