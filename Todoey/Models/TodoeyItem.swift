//
//  TodoeyItem.swift
//  Todoey
//
//  Created by Omar Assidi on 28/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import RealmSwift
import Foundation

class TodoeyItem: Object {
    @objc dynamic var title: String?
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var createdAt: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
