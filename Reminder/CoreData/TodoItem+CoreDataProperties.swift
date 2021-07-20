//
//  TodoItem+CoreDataProperties.swift
//  Reminder
//
//  Created by Gabriela Sillis on 20/07/21.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var task: String?
    @NSManaged public var createdDate: Date?

}

extension TodoItem : Identifiable {

}
