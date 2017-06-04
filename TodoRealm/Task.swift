//
//  Task.swift
//  TodoRealm
//
//  Created by Hafiz on 04/06/2017.
//  Copyright © 2017 Hafiz. All rights reserved.
//

import RealmSwift

// Task model
class Task: Object {
    dynamic var name = ""
    dynamic var completed = false
}
