//
//  addNewAccountViewController.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/16.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import CoreData

class AddNewAccountViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var payment: UITextField! {
        didSet {
            payment.delegate = self
        }
    }
   
    var paymentTypes: [PaymentType]! = []
    var coreDataStack: CoreDataStack!
    var newAccount: MoneyAccount!
    
    var paymentTypeSelected: PaymentType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get default type data
        getAccountType()
        
        let monenyEntity = NSEntityDescription.entityForName(ConstantsData.EntityNames.MoneyAccountEntity, inManagedObjectContext: coreDataStack.context)
        newAccount = MoneyAccount(entity: monenyEntity!, insertIntoManagedObjectContext: coreDataStack.context)
        
        payment.becomeFirstResponder()
        self.addDoneButtonForTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getAccountType() {
        let paymentTypeFetchRequest = NSFetchRequest(entityName: ConstantsData.EntityNames.PaymentTypeEntity)
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: paymentTypeFetchRequest) {
            [unowned self]
            (result: NSAsynchronousFetchResult) -> Void in
            self.paymentTypes = result.finalResult as! [PaymentType]
            self.collectionView.reloadData()
            // set default type
            self.paymentTypeSelected = self.paymentTypes[0]
        }
        do {
            try coreDataStack.context.executeRequest(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error.userInfo)")
        }
    }
    
    
    // MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ConstantsData.Identifiers.CollectionCell, forIndexPath: indexPath) as! PaymentTypesCollectionViewCell
        cell.paymentTypeImage.image = UIImage(named: paymentTypes[indexPath.item].typeIconName!)
        cell.paymentTypeName.text = paymentTypes[indexPath.item].typeName
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PaymentTypesCollectionViewCell
        cell.backgroundColor = UIColor.greenColor()
        if let collectionCellText = cell.paymentTypeName.text {
            paymentTypeSelected.typeName = collectionCellText
            
            for item in paymentTypes {
                if item.typeName == collectionCellText {
                    paymentTypeSelected = item
                }
            }
            
        }
//        print(paymentTypeSelected)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PaymentTypesCollectionViewCell
        cell.backgroundColor = UIColor.grayColor()
    }
    
    
    // MARK: - Button
    // add new account
    @IBAction func addAccount(sender: AnyObject) {
        // set id
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        let dateString = dateFormatter.stringFromDate(date)
        let dateNub32 = Int64(dateString)
        let dateNub = NSNumber(longLong: dateNub32!)
        newAccount.id = dateNub
        
        newAccount.payment = Float(payment.text!)
        newAccount.paymentType = paymentTypeSelected
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        newAccount.accountDay = dateFormatter1.stringFromDate(date)
        newAccount.accountDate = date
        
        print(newAccount)
        
        do {
            try coreDataStack.context.save()
        } catch let error as NSError {
            print("Cloud not save \(error)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // cancel and return
    @IBAction func cancelAndReturn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func addDoneButtonForTextField() {
        let doneBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneBarButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneBarAction"))
        
        let items: [UIBarButtonItem] = [flexSpace,doneBarButton]
        doneBar.setItems(items, animated: false)
        
        self.payment.inputAccessoryView = doneBar
    }
    
    func doneBarAction() {
        payment.resignFirstResponder()
    }

}
