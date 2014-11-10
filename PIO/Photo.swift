//
//  Photo.swift
//  PIO
//
//  Created by Andrew Donoho on 11/3/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var imageData: NSData
    @NSManaged var item: Item

}
