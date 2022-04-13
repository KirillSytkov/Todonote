//
//  Category.swift
//  Todonote
//
//  Created by Kirill Sytkov on 12.04.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var title: String
    @Persisted var items: List<Item>
}
