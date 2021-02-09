//
//  StorageService.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

protocol StorageService {
	func get<Object: Equatable>(for key: String) -> [Object]
	func add<Object: Equatable>(_ object: Object, key: String)
	func remove<Object: Equatable>(_ object: Object, key: String)
}

extension UserDefaults: StorageService {

	func get<Object: Equatable>(for key: String) -> [Object] {
		let objects = array(forKey: key) as? [Object]
		return objects ?? []
	}

	func add<Object: Equatable>(_ newObject: Object, key: String) {
		var objects = array(forKey: key) as? [Object] ?? []
		guard objects.contains(newObject) == false else { return }

		objects.append(newObject)
		set(objects, forKey: key)
	}

	func remove<Object: Equatable>(_ object: Object, key: String) {
		var objects = array(forKey: key) as? [Object] ?? []
		guard objects.contains(object) else { return }

		objects.removeAll(where: { $0 == object })
		set(objects, forKey: key)
	}
}
