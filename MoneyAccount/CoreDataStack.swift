//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Rick on 15/9/7.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    let context: NSManagedObjectContext
    let psc: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    var store: NSPersistentStore? 
    
    init() {
        // 从硬盘加载managed object model，这里通过读取momd目录下的编译后的.xcdatamodeld文件实现
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("MoneyAccount", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        // 一旦初始化了NSManagedObjectModel，下一步是创建PSC, PSC用于桥接model和persistentStore
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // Context的初始化没有任何参数，我们将psc连接到context上
        // 使用异步fetch，需要将type设置为MainQueueConcurrencyType
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        // 我们不需要手工创建ps, psc会帮我们创建它。我们只需要为psc提供所需的PS类型，一些配置，存放路径即可
        let documentsURL = applicationDocumentsDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent("MoneyAccount")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        var error: NSError? = nil
        store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)
        
        if store == nil {
            println("Error adding persistent store: \(error)")
            abort()
        }
    }
    
    func saveContext() {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            println("Could not save: \(error), \(error?.userInfo)")
        }
    }
    
    // 获取应用程序documents diretory的url
    // swift中必须初始化所有变量后才可以调用函数
    func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as! Array<NSURL>
        
        return urls[0]
    }

    

}