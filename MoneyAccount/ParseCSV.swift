//
//  ParseCSV.swift
//  MoneyAccount
//
//  Created by Rick on 15/9/17.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import Foundation

func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding) throws -> [(typeName:String, typeIconName:String, typeDescription: String)] {
    var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
    // Load the CSV file and parse it
    let delimiter = ","
    var items:[(typeName:String, typeIconName:String, typeDescription: String)]?
    
    do {
        let content = try String(contentsOfURL: contentsOfURL, encoding: encoding)
        items = []
        let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        
        for line in lines {
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.rangeOfString("\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:NSScanner = NSScanner(string: textToScan)
                    while textScanner.string != "" {
                        
                        if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpToString("\"", intoString: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpToString(delimiter, intoString: &value)
                        }
                        
                        // Store the value into the values array
                        values.append(value as! String)
                        
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = NSScanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.componentsSeparatedByString(delimiter)
                }
                
                // Put the values into the tuple and add it to the items array
                let item = (typeName: values[0], typeIconName: values[1], typeDescription: values[2])
                items?.append(item)
            }
        }
    } catch let error1 as NSError {
        error = error1
    }
    
    if let value = items {
        return value
    }
    throw error
}










