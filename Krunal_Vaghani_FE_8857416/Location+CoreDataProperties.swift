//
//  Location+CoreDataProperties.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/11/23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locationId: UUID?
    @NSManaged public var longitude: Double
    @NSManaged public var imageUrl: String?

}

extension Location : Identifiable {

}
