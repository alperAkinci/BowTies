//
//  BowTie+CoreDataProperties.swift
//  Bow Ties
//
//  Created by Alper on 03/03/16.
//  Copyright © 2016 allperr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BowTie {

    @NSManaged var timesWorn: NSNumber?
    @NSManaged var searchKey: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var photoData: NSData?
    @NSManaged var name: String?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var tintColor: NSObject?

}
