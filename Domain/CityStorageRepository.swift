//
//  CityStorageRepository.swift
//  Domain
//
//  Created by Ewelina on 09/02/2021.
//

import Foundation

public protocol CityStorageRepository {
	func get(_ completion: @escaping (Result<[String], Domain.Error>) -> Void)
	func add(_ city: City, completion: @escaping (Result<Void, Error>) -> Void)
	func delete(_ city: City, completion: @escaping (Result<Void, Domain.Error>) -> Void)
}
