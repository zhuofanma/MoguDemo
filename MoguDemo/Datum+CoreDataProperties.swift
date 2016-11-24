//
//  Datum+CoreDataProperties.swift
//  MoguDemo
//
//  Created by Zhuofan Ma on 11/23/16.
//  Copyright © 2016 Zhuofan Ma. All rights reserved.
//

import Foundation
import CoreData

enum LoadingStatus:Int32 {
    case loading, succeeded, failed
}

extension Datum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Datum> {
        return NSFetchRequest<Datum>(entityName: "Datum");
    }

    @NSManaged public var title: String?
    @NSManaged public var loadingStatusValue:NSNumber?
    @NSManaged public var createdAt:NSDate?
    @NSManaged public var imageURL:String?
    @NSManaged public var imageData:Data?
    
    var loadingStatus:LoadingStatus {
        get {
            return LoadingStatus(rawValue: self.loadingStatusValue!.int32Value)!
        }
        set {
            self.loadingStatusValue = NSNumber(value: newValue.rawValue as Int32)
        }
    }
}
