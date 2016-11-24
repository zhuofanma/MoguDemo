//
//  Datum+CoreDataClass.swift
//  MoguDemo
//
//  Created by Zhuofan Ma on 11/23/16.
//  Copyright © 2016 Zhuofan Ma. All rights reserved.
//

import Foundation
import CoreData


public class Datum: NSManagedObject {
    
    convenience init(title:String?=nil,insertInto context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName:"Datum", in: context) {
            self.init(entity:ent, insertInto: context)
            self.title = title
            self.loadingStatus = .loading
            self.createdAt = NSDate()
        } else {
            fatalError("Unable to find Datum name!")
        }
    }
}
