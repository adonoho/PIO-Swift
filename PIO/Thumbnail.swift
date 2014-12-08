//
//  Thumbnail.swift
//  PIO
//
//  Created by Andrew Donoho on 12/1/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import Foundation
import CoreData

class Thumbnail: NSManagedObject {

    @NSManaged var data: NSData?
    @NSManaged var item: Item?

}
