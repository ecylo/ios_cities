//
//  CityStorageRepository.swift
//  Platform
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation
import Domain

final class CityStorageRepository: Domain.CityStorageRepository {
	private let storageService: StorageService
	private let key: String

	init(storageService: StorageService = UserDefaults.standard,
		 key: String = "favourite-cities") {
		self.storageService = storageService
		self.key = key
	}

	func get(_ completion: @escaping (Result<[String], Error>) -> Void) {
		let cityIds: [String] = storageService.get(for: key)
		completion(.success(cityIds))
	}

	func add(_ city: City, completion: @escaping (Result<Void, Error>) -> Void) {
		storageService.add(city.name, key: key)
		completion(.success(()))
	}

	func delete(_ city: City, completion: @escaping (Result<Void, Error>) -> Void) {
		storageService.remove(city.name, key: key)
		completion(.success(()))
	}
}
