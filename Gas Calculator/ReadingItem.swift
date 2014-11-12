//
//  ReadingItem.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import Foundation
import CoreData

@objc( ReadingItem )

class ReadingItem: NSManagedObject {

    @NSManaged var reading: NSNumber
    @NSManaged var date: NSDate

}
