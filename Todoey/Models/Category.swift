//
//  Category.swift
//  Todoey
//
//  Created by Omar Assidi on 28/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import RealmSwift
import Foundation

class Category: Object {
    @objc dynamic var name: String?
    @objc dynamic var createdAt: Date = Date()
    let items = List<TodoeyItem>()
}
