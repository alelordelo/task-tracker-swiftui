//
//  Task.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 03/11/2020.
//

import Foundation
import RealmSwift

enum TaskStatus: String {
    case Open
    case InProgress
    case Complete
}

class Task: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String?
    @objc dynamic var status: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }

    var statusEnum: TaskStatus {
        get {
            return TaskStatus(rawValue: status) ?? .Open
        }
        set {
            status = newValue.rawValue
        }
    }

    convenience init(partition: String, name: String) {
        self.init()
        self._partition = partition
        self.name = name
    }
}

extension Task: Identifiable {
    var id: String {
        _id.stringValue
    }
}

struct Member: Identifiable {
    let id: String
    let name: String

    init(document: Document) {
        self.id = document["_id"]!!.stringValue!
        self.name = document["name"]!!.stringValue!
    }
}
