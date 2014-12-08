//
//  Item.swift
//  PIO
//
//  Created by Andrew Donoho on 10/27/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var timestamp: NSTimeInterval
    @NSManaged var done: Bool
    @NSManaged var problem: String?
    @NSManaged var title: String?
    
    // Relations
    @NSManaged var photo: Photo?
    @NSManaged var thumbnail: Thumbnail?
    
}
