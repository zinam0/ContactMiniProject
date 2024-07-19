//
//  Contact+CoreDataProperties.swift
//  ContactProject
//
//  Created by 남지연 on 7/18/24.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var imageUrl: Data?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
}

extension Contact : Identifiable {

}
