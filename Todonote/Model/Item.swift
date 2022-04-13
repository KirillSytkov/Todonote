//
//  Item.swift
//  Todonote
//
//  Created by Kirill Sytkov on 12.04.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var note: String
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
}
