//
//  ImageMetaData.swift
//  PIO
//
//  Created by Andrew Donoho on 2014/11/10.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import Foundation
import CoreData

class ImageMetaData: NSManagedObject {

    @NSManaged var data: NSData?
    @NSManaged var photo: Photo

}
