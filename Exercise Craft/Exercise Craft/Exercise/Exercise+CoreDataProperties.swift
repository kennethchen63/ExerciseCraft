//
//  Exercise+CoreDataProperties.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 11/29/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var prev: Int64
    @NSManaged public var current: Int64
    @NSManaged public var name: String?
    @NSManaged public var next: Int64
    @NSManaged public var reps: Int64
    @NSManaged public var sets: Int64

}
