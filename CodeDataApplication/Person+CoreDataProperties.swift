//
//  Person+CoreDataProperties.swift
//  CodeDataApplication
//
//  Created by user228677 on 7/19/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var age: String?
    @NSManaged public var personId: UUID?

}

extension Person : Identifiable {

}
